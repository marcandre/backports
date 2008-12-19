require File.dirname(__FILE__) + '/test_helper'
# Warning: ugly...

class XYZ
  include Packable
  def write_packed(io, options)
    io << "xyz"
  end
  def self.unpack_string(s, options)
    raise "baddly packed XYZ: #{s}" unless "xyz" == s
    XYZ.new
  end
end

class TestingPack < Test::Unit::TestCase
  
  context "Original form" do
    should "pack like before" do
      assert_equal "a  \000\000\000\001", ["a",1,66].pack("A3N")
    end

    should "be equivalent to new form" do
      assert_equal ["a",1,2.34, 66].pack({:bytes=>3}, {:bytes=>4, :endian=>:big}, {:precision=>:double, :endian=>:big}), ["a",1,2.34, 66].pack("A3NG")
    end
  end
  
  def test_shortcuts
    assert_equal 0x123456.pack(:short), 0x123456.pack(:bytes => 2)
    assert_equal 0x3456, 0x123456.pack(:short).unpack(:short)
  end
  
  def test_custom_form
    assert_equal "xyz", XYZ.new.pack 
    assert_equal XYZ, "xyz".unpack(XYZ).class
  end
  
  def test_pack_default
    assert_equal "\000\000\000\006", 6.pack
    assert_equal "abcd", "abcd".pack
    assert_equal "\000\000\000\006abcd", [6,"abcd"].pack
    String.packers.set :flv_signature, :bytes => 3, :fill => "FLV"
    assert_equal "xFL", "x".pack(:flv_signature)
  end
  
  def test_integer
    assert_equal "\002\001\000", 258.pack(:bytes => 3, :endian => :little)
    assert_equal 258, Integer.unpack("\002\001\000", :bytes => 3, :endian => :little)
    assert_equal (1<<24)-1, -1.pack(:bytes => 3).unpack(Integer, :bytes => 3, :signed => false)
    assert_equal -1, -1.pack(:bytes => 3).unpack(Integer, :bytes => 3, :signed => true)
  end
  
  def test_io
    io = StringIO.new("\000\000\000\006abcd!")
    n, s = io >> [Fixnum, {:signed=>false}] >> [String, {:bytes => 4}]
    assert_equal n, 6
    assert_equal s, "abcd"
    assert_equal "!", io.read
  end
  
  context "Filters" do
    context "for Object" do
      Object.packers.set :generic_class_writer do |packer|
        packer.write do |io|
          io << self.class.name << self
        end
      end
      should "be follow accessible everywhere" do
        assert_equal "StringHello", "Hello".pack(:generic_class_writer)
        assert_equal "Fixnum\000\000\000\006", 6.pack(:generic_class_writer)
      end
    end
    context "for a specific class" do
      String.packers.set :specific_writer do |packer|
        packer.write do |io|
          io << "Hello"
        end
      end

      should "be accessible only from that class and descendants" do
        assert_equal "Hello", "World".pack(:specific_writer)
        assert_raise RuntimeError do
          6.pack(:specific_writer)
        end
      end
    end
  end
    
end
require File.dirname(__FILE__) + '/test_helper'
# Warning: ugly...
class MyHeader < Struct.new(:signature, :nb_blocks)
  include Packable
  
  def write_packed(packedio, options)
    packedio << [signature, {:bytes=>3}] << [nb_blocks, :short]
  end

  def read_packed(packedio, options)
    self.signature, self.nb_blocks = packedio >> [String, {:bytes => 3}] >> :short
  end
  
  def ohoh
    :ahah
  end
end


class PackableDocTest < Test::Unit::TestCase 
  def test_doc

    assert_equal  [1,2,3], StringIO.new("\000\001\000\002\000\003").each(:short).to_a


  	String.packers.set :flv_signature, :bytes => 3, :fill => "FLV"

    assert_equal "xFL", "x".pack(:flv_signature)

    String.packers do |c|
      c.set :merge_all, :fill => "*"	# Unless explicitly specified, :fill will now be "*"
      c.set :default, :bytes => 8     # If no option is given, this will act as default
    end
    
    assert_equal "ab******", "ab".pack
    assert_equal "ab**", "ab".pack(:bytes=>4)
    assert_equal "ab", "ab".pack(:fill => "!")
    assert_equal "ab!!", "ab".pack(:fill => "!", :bytes => 4)
    
    String.packers do |c|
  		c.set :creator, :bytes => 4
  		c.set :app_type, :creator
  		c.set :default, {} # Reset to a sensible default...
      c.set :merge_all, :fill => " "
  	end
    
    assert_equal "hello".pack(:app_type), "hell"
    
    assert_equal [["sig", 1, "hello, w"]]*4,
    [
    lambda { |io| io >> :flv_signature >> Integer >> [String, {:bytes => 8}]                     },
    lambda { |io| io.read(:flv_signature, Integer, [String, {:bytes => 8}])                      },
    lambda { |io| io.read(:flv_signature, Integer, String, {:bytes => 8})                        },
    lambda { |io| [io.read(:flv_signature), io.read(Integer), io.read(String, {:bytes => 8})]    }
    ].map {|proc| proc.call(StringIO.new("sig\000\000\000\001hello, world"))}
    
    
    ex = "xFL\000\000\000BHello   "
    [
    lambda { |io| io << "x".pack(:flv_signature) << 66.pack << "Hello".pack(:bytes => 8)},   # returns io
    lambda { |io| io << ["x", 66, "Hello"].pack(:flv_signature, :default , {:bytes => 8})},  # returns io
    lambda { |io| io.write("x", :flv_signature, 66, "Hello", {:bytes => 8})             },   # returns the # of bytes written
    lambda { |io| io.packed << ["x",:flv_signature] << 66 << ["Hello", {:bytes => 8}]   }    # returns  io.packed
    ].zip([StringIO, StringIO, ex.length, StringIO.new.packed.class]) do |proc, compare|
      ios = StringIO.new
      assert_operator compare, :===, proc.call(ios)
      ios.rewind
      assert_equal ex, ios.read, "With #{proc}"
    end
    
    #insure StringIO class is not affected
    ios = StringIO.new
    ios.packed
    ios << 66
    ios.rewind
    assert_equal "66", ios.read
    
    
    String.packers.set :length_encoded do |packer|
      packer.write  { |io| io << length << self }
      packer.read   { |io| io.read(io.read(Integer)) }
    end
    
    assert_equal "\000\000\000\006hello!", "hello!".pack(:length_encoded)
    assert_equal ["this", "is", "great!"], ["this", "is", "great!"].pack(*[:length_encoded]*3).unpack(*[:length_encoded]*3)
  
    h = MyHeader.new("FLV", 65)
    assert_equal "FLV\000A", h.pack
    h2, = StringIO.new("FLV\000A") >> MyHeader
    assert_equal h, h2
    assert_equal h.ohoh, h2.ohoh


  
    Object.packers.set :with_class do |packer|
      packer.write { |io| io << [self.class.name, :length_encoded] << self }
      packer.read  do |io|
        klass = eval(io.read(:length_encoded))
        io.read(klass)
      end
    end
    ar = [42, MyHeader.new("FLV", 65)]
    assert_equal ar, ar.pack(:with_class, :with_class).unpack(:with_class, :with_class)
  end
end
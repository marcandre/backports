# encoding: utf-8
$KCODE = 'u' if RUBY_VERSION < '1.9'
require 'test_helper'

class StringTest < Test::Unit::TestCase
  context "String" do
    context "#ascii_only?" do
      should "conform to doc" do
        assert_equal true, "dog".ascii_only?
        assert_equal false, "δog".ascii_only?
        assert_equal true, "\x00 to \x7f".ascii_only?
      end
    end

    context "#chars" do
      should "conform to doc" do
        assert_equal ["d", "o", "g"], "dog".chars.to_a
        assert_equal ["δ", "o", "g"], "δog".chars.to_a
        result = [] 
        "δog".chars.each {|b| result << b }
        assert_equal ["δ", "o", "g"], result
      end
    end
    
    context "#chr" do
      should "conform to doc" do
        assert_equal "d", "dog".chr
        assert_equal "δ", "δog".chr
      end
    end

    context "#codepoints" do
      should "conform to doc" do
        assert_equal [100, 111, 103], "dog".codepoints.to_a 
        assert_equal [948, 111, 103], "δog".codepoints.to_a  # Note, there is an error in Pragmatics' book
        result = [] 
        assert_equal "δog", "δog".codepoints.each {|b| result << b }
        assert_equal [948, 111, 103], result
      end
    end

    context "#start_with" do
      should "conform to doc" do
        assert "Apache".start_with?("Apa")
        assert "ruby code".start_with?("python", "perl", "ruby")
        assert !"hello world".start_with?("world")
      end
    end

    context "#end_with" do
      should "conform to doc" do
        assert "Apache".end_with?("ache")
        assert "ruby code".end_with?("python", "perl", "code")
        assert !"hello world".end_with?("hello")
      end
    end
    
    context "#partition" do
      should "conform to doc" do
        assert_equal ["THX", "11", "38"], "THX1138".partition("11")
        assert_equal ["THX", "11", "38"], "THX1138".partition(/\d\d/)
        assert_equal ["THX1138", "", ""], "THX1138".partition("99")
      end
    end
    
    context "#rpartition" do
      should "conform to doc" do
        assert_equal ["THX1", "1", "38"], "THX1138".rpartition("1")   
        assert_equal ["THX1", "13", "8"], "THX1138".rpartition(/1\d/) 
        assert_equal ["", "", "THX1138"], "THX1138".rpartition("99")
      end
    end
  end
end
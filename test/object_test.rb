require 'test_helper'

class ObjectTest < Test::Unit::TestCase
  class KlassWithSecret
    def initialize
      @secret = 99
    end
  end
  context "Object" do
    context "#instance_exec" do
      should "conform to doc" do
        k = KlassWithSecret.new
        assert_equal 104, k.instance_exec(5) {|x| @secret+x }
      end
    end
    
    context "#define_singleton_method" do
      should "conform to doc" do
        a = "cat" 
        a.define_singleton_method(:speak) do 
          "miaow"
        end 
        assert_equal "miaow", a.speak 
        
        KlassWithSecret.class_eval do 
          define_method(:one) { "instance method" } 
          define_singleton_method(:two) { "class method" } 
        end 
        t = KlassWithSecret.new 
        assert_equal "instance method", t.one 
        assert_equal "class method", KlassWithSecret.two
      end
    end
  end
end

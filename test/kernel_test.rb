require 'test_helper'

$outside = __callee__
def fred 
  "I'm in #{__callee__.inspect}" 
end 

class KernelTest < Test::Unit::TestCase
  context "Kernel" do
    context ".loop" do
      should "conform to doc" do
        enum1 = [1, 2, 3].to_enum 
        enum2 = [10, 20].to_enum 
        r = []
        loop do 
          r << enum1.next + enum2.next 
        end
        assert_equal [11,22], r
      end
    end
    

    context ".__callee__" do
      should "conform to doc" do
        assert_equal "I'm in :fred", fred
        assert_equal nil, $outside
      end
    end
  end
end
require 'test_helper'

$outside = __callee__
def fred 
  "I'm in #{__callee__.inspect}" 
end 

class KernelTest < Test::Unit::TestCase
  context "Kernel" do
    context ".loop" do
      should "catch StopIteration" do
        i = 0
        r = []
        loop do 
          r << i
          i += 1
          raise StopIteration if i > 2
        end
        assert_equal [0, 1, 2], r
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
require 'test_helper'

class BindingTest < Test::Unit::TestCase
  class Demo
    def initialize(n)
      @secret = n
    end
    def get_binding
      return binding()
    end
  end

  context "Binding" do
    context "#eval" do
      should "conform to doc" do
        assert_equal 99, Demo.new(99).get_binding.eval("@secret")
      end
    end
  end
end
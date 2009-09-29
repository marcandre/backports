require 'test_helper'


class MethodMissingTest < Test::Unit::TestCase
  
  class A
    def respond_to_missing? method
      :ok_if_missing == method
    end

    def method_missing method, *args
      :bar
    end
  end

  context "#respond_to?" do
    should "takes #respond_to_missing? into account" do
      assert_equal true, A.new.respond_to?(:ok_if_missing)
      assert_equal false, A.new.respond_to?(:not_ok_if_missing)
    end
  end
  
  context "#method" do
    should "returns a nice Method with respond_to_missing?" do
      assert_equal :bar, A.new.method(:ok_if_missing).call
      assert_raise(NameError){ A.new.method(:not_ok_if_missing) }
    end
  end

  context "Method#unbind" do
    should "works for missing Methods" do
      assert_equal :ok_if_missing, A.new.method(:ok_if_missing).unbind.name
    end
  end


end

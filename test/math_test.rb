require 'test_helper'

class MathTest < Test::Unit::TestCase
  context "Math" do
    context ".log" do
      should "accept one argument" do
        assert_nothing_raised(ArgumentError) { Math.log(1) }
      end

      should "accept two arguments" do
        assert_nothing_raised(ArgumentError) { Math.log(2, 2) }
      end

      should "accept valid arguments" do
        assert_nothing_raised(TypeError) { Math.log(2, 2) }
        assert_nothing_raised(TypeError) { Math.log(2, 2.0) }
      end

      should "reject invalid arguments" do
        assert_raises(TypeError) { Math.log(2, nil) }
        assert_raises(TypeError) { Math.log(2, "2") }
      end

      should "return the correct value" do
        assert_equal 0.0, Math.log(1)
        assert_equal 1.0, Math.log(Math::E)
        assert_equal 3.0, Math.log(Math::E**3)
        assert_equal 3.0, Math.log(8, 2)
      end
    end

    context ".log2" do
      should "be defined" do
        assert_respond_to Math, :log2
      end

      should "accept one argument" do
        assert_nothing_raised(ArgumentError) { Math.log2(1) }
      end

      should "accept valid arguments" do
        assert_nothing_raised(TypeError) { Math.log2(1) }
        assert_nothing_raised(TypeError) { Math.log2(1.0) }
      end

      should "reject invalid arguments" do
        assert_raises(TypeError) { Math.log2(nil) }
        assert_raises(TypeError) { Math.log2("1") }
      end

      should "return the correct value" do
        assert_equal  0.0, Math.log2(1)
        assert_equal  1.0, Math.log2(2)
        assert_equal 15.0, Math.log2(32768)
        assert_equal 16.0, Math.log2(65536)
      end
    end
  end
end

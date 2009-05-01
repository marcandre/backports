require 'test_helper'

class SymbolTest < Test::Unit::TestCase
  context "Symbol" do
    context "comparison" do
      should "work as expected" do
        assert_equal false, :abc == :def
        assert_equal true, :abc == :abc
        assert_equal false, :abc == "abc"
        assert_equal false, :abc > :def
        assert_equal true, :abc < :def
        assert_raise(ArgumentError) {:abc < "def"}
      end
    end

    context "string ops" do
      should "work as expected" do
        assert_equal :HELLO, :hello.upcase
        assert_equal 5, :hello.length
      end
    end
  end
end
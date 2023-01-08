require './test/test_helper'
require 'backports/3.2.0/enumerator/product'

class ProductTest < Test::Unit::TestCase
  def test_product
    ##
    ## Enumerator::Product
    ##

    # 0-dimensional
    e = Enumerator::Product.new
    assert_instance_of(Enumerator::Product, e)
    assert_kind_of(Enumerator, e)
    assert_equal(1, e.size)
    elts = []
    e.each { |x| elts << x }
    assert_equal [[]], elts
    assert_equal elts, e.to_a
    heads = []
    e.each { |x,| heads << x }
    assert_equal [nil], heads

    # 1-dimensional
    e = Enumerator::Product.new(1..3)
    assert_instance_of(Enumerator::Product, e)
    assert_kind_of(Enumerator, e)
    assert_equal(3, e.size)
    elts = []
    e.each { |x| elts << x }
    assert_equal [[1], [2], [3]], elts
    assert_equal elts, e.to_a

    # 2-dimensional
    e = Enumerator::Product.new(1..3, %w[a b])
    assert_instance_of(Enumerator::Product, e)
    assert_kind_of(Enumerator, e)
    assert_equal(3 * 2, e.size)
    elts = []
    e.each { |x| elts << x }
    assert_equal [[1, "a"], [1, "b"], [2, "a"], [2, "b"], [3, "a"], [3, "b"]], elts
    assert_equal elts, e.to_a
    heads = []
    e.each { |x,| heads << x }
    assert_equal [1, 1, 2, 2, 3, 3], heads

    # Reject keyword arguments
    assert_raise(ArgumentError) {
      Enumerator::Product.new(1..3, foo: 1, bar: 2)
    }

    ##
    ## Enumerator.product
    ##

    # without a block
    e = Enumerator.product(1..3, %w[a b])
    assert_instance_of(Enumerator::Product, e)

    # with a block
    elts = []
    ret = Enumerator.product(1..3) { |x| elts << x }
    assert_equal(nil, ret)
    assert_equal [[1], [2], [3]], elts
    assert_equal elts, Enumerator.product(1..3).to_a

    # an infinite enumerator and a finite enumerable
    e = Enumerator.product(1.., 'a'..'c')
    assert_equal(Float::INFINITY, e.size)
    assert_equal [[1, "a"], [1, "b"], [1, "c"], [2, "a"]], e.take(4)

    # an infinite enumerator and an unknown enumerator
    e = Enumerator.product(1.., Enumerator.new { |y| y << 'a' << 'b' })
    assert_equal(Float::INFINITY, e.size)
    assert_equal [[1, "a"], [1, "b"], [2, "a"], [2, "b"]], e.take(4)

    # an infinite enumerator and an unknown enumerator
    e = Enumerator.product(1..3, Enumerator.new { |y| y << 'a' << 'b' })
    assert_equal(nil, e.size)
    assert_equal [[1, "a"], [1, "b"], [2, "a"], [2, "b"]], e.take(4)

    # Reject keyword arguments
    assert_raise(ArgumentError) {
      Enumerator.product(1..3, foo: 1, bar: 2)
    }
  end
end

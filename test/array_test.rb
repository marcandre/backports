require 'test_helper'

class ArrayTest < Test::Unit::TestCase
  context "Array" do
    context "#reverse_each" do
      should "return an enumerator when no block is given" do
        assert_equal [4,3,2], [1,2,3,4].reverse_each.take(3)
      end
    end

    context "#flatten" do
      should "conform to doc" do
        s = [ 1, 2, 3 ]           #=> [1, 2, 3]
        t = [ 4, 5, 6, [7, 8] ]   #=> [4, 5, 6, [7, 8]]
        a = [ s, t, 9, 10 ]       #=> [[1, 2, 3], [4, 5, 6, [7, 8]], 9, 10]
        assert_equal [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], a.flatten
        a = [ 1, 2, [3, [4, 5] ] ]
        assert_equal [1, 2, 3, [4, 5]], a.flatten(1)
      end
    end

    context "#index" do
      should "conform to doc" do
        a = [ "a", "b", "c" ]
        assert_equal 1, a.index("b")
        assert_equal nil, a.index("z")
        assert_equal 1, a.index{|x|x=="b"}
      end
    end

    context "#sample" do
      should "conform to doc" do
        assert_equal nil, [].sample
        assert_equal [], [].sample(5)
        assert_equal 42, [42].sample
        assert_equal [42], [42].sample(5)
        a = [ :foo, :bar, 42 ]
        s = a.sample(2)
        assert_equal 2, s.size
        assert_equal 1, (a-s).size
        assert_equal [], a-(0..20).sum{a.sample(2)} # ~ 3e-10
      end
    end
  end
end

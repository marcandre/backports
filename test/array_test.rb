require 'test_helper'

class ArrayTest < Test::Unit::TestCase
  context "Array" do
    context "#combination" do
      should "conform to doc" do
        a = [ "a", "b", "c" ] 
        assert_equal [["a"], ["b"], ["c"]], a.combination(1).to_a
        assert_equal [["a", "b"], ["a", "c"], ["b", "c"]], a.combination(2).to_a 
        assert_equal [["a", "b", "c"]], a.combination(3).to_a
        assert_equal [], a.combination(4).to_a
      end
    end
        
    context "#flatten" do
      should "conform to doc" do
        s = [ 1, 2, 3 ]
        t = [ 4, 5, 6, [7, 8] ]
        a = [ s, t, 9, 10 ]
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

    context "#reverse_each" do
      should "return an enumerator when no block is given" do
        assert_equal [4,3,2], [1,2,3,4].reverse_each.take(3)
      end
    end

    context "#pop" do
      should "conform to doc" do
        a = %w{ f r a b j o u s } 
        assert_equal "s", a.pop
        assert_equal ["f", "r", "a", "b", "j", "o", "u"] , a
        assert_equal ["j", "o", "u"], a.pop(3)
        assert_equal ["f", "r", "a", "b"] , a
      end
    end
    
    context "#product" do
      should "conform to doc" do
        assert_equal  [[1, 3], [1, 4], [2, 3], [2, 4]], [1, 2].product([3, 4])
        assert_equal [[1, 3, 5], [1, 4, 5], [2, 3, 5], [2, 4, 5]], [1, 2].product([3, 4], [5])
        assert_equal [[1], [2]],  [1, 2].product
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
        assert_equal [], a-(0..20).sum{a.sample(2)}
      end
    end
    
    context "#shift" do
      should "conform to doc" do
        args = [ "-m", "-q", "-v", "filename" ] 
        assert_equal "-m", args.shift
        assert_equal ["-q", "-v"], args.shift(2)
        assert_equal ["filename"], args
      end
    end
  end
end

require 'test_helper'

class BackportsTest < Test::Unit::TestCase
  context "Enumerable" do
    context "#find_index" do
      should "conform to doc" do
        assert_equal 3, %w{ant bat cat dog}.find_index {|item| item =~ /g/ }
        assert_equal nil, %w{ant bat cat dog}.find_index {|item| item =~ /h/ }
      end

      should "#work for enumerables too" do
        assert_equal 69-42, (42..666).find_index(69)
      end
    end

    context "#take" do
      should "conform to doc" do
        assert_equal [1, 2, 3], (1..7).take(3)
        assert_equal [["a", 1], ["b", 2]], { 'a'=>1, 'b'=>2, 'c'=>3 }.take(2)
      end
    
      should "only consume what's needed" do
        assert_equal [], Enumerator.new(nil).take(0)
        assert_raises(NoMethodError) { Enumerator.new(nil).take(1) }
      end
    end
  
    context "#take_while" do
      should "conform to doc" do
        assert_equal [1,2], (1..7).take_while {|item| item < 3 }
        assert_equal [2,4,6], [ 2, 4, 6, 9, 11, 16 ].take_while(&:even?)
      end

      should "work with infinite enumerables" do
        assert_equal [1,2], (1..(1/0.0)).take_while {|item| item < 3 }
      end
    end
  
    context "#drop" do
      should "conform to doc" do
        assert_equal [5, 8, 13], [ 1, 1, 2, 3, 5, 8, 13 ].drop(4)
        assert_equal [], [ 1, 1, 2, 3, 5, 8, 13 ].drop(99)
      end
    
      should "work with enums" do
        assert_equal [14,15], (10...16).drop(4)
      end
    end
  
    context "#drop_while" do
      should "conform to doc" do
        assert_equal [8, 13], [ 1, 1, 2, 3, 5, 8, 13 ].drop_while {|item| item < 6 } 
      end

      should "work with enums" do
        assert_equal [14,15], (10...16).drop_while {|item| item < 14}
      end

      should "work with extemity cases" do
        assert_equal [10,11,12,13,14,15], (10...16).drop_while {|item| false}
        assert_equal [], (10...16).drop_while {|item| true}
      end
    end
    
    context "#reverse_each" do
      should "work as expected" do
        assert_equal [4,3,2], (1..4).reverse_each.take(3)
      end
    end
    
    context "#each_slice" do
      should "conform to doc" do
        res = []
        (1..10).each_slice(4){|ar| res << ar}
        assert_equal [[1, 2, 3, 4],[5, 6, 7, 8],[9, 10]], res
        assert_equal [[1, 2, 3, 4],[5, 6, 7, 8],[9, 10]], (1..10).each_slice(4).to_a
      end
    end
    
    context "#count" do
      should "conform to doc" do
        assert_equal 4, (1..4).count
        assert_equal 1, (1..4).count(3)
        assert_equal 2, (1..4).count{|obj| obj > 2 } 
      end
    end

    context "#cycle" do
      should "conform to doc" do
        assert_equal ["a", "b", "c", "a", "b", "c"], ('a'..'c').cycle(2).to_a
      end
    end
    
    context "#each_cons" do
      should "conform to doc" do
        assert_equal [[1,2],[2,3],[3,4]], (1..4).each_cons(2).to_a
      end
    end
    
    context "#group_by" do
      should "conform to doc" do
        x = (1..5).group_by{|item| item.even? ? :even : :odd }
        assert_equal({:even => [2,4], :odd => [1,3,5]}, x)
        assert_equal nil, x[:xyz]
      end
    end
  end #Enumerable
  
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
  end
  
  context "Hash" do
    should "should be constructible from key value pairs" do
      assert_equal({1 => 2, 3 => 4}, Hash[[[1,2],[3,4]]])
    end
    
    context "#default_proc=" do
      should "conform to doc" do
        h = { :foo => :bar }
        h.default = "Go fish"
        h.default_proc=lambda do |hash, key| 
          key + key 
        end 
        assert_equal :bar, h[:foo]
        assert_equal 4, h[2]
        assert_equal "catcat", h["cat"]
        h.default=nil
        assert_equal nil, h[2]
        assert_equal nil, h["cat"]
      end
    end
  end
  
end

require 'test_helper'

class BackportsTest < Test::Unit::TestCase
  context "find_index" do
    should "conform to doc" do
      assert_equal 3, %w{ant bat cat dog}.find_index {|item| item =~ /g/ }
      assert_equal nil, %w{ant bat cat dog}.find_index {|item| item =~ /h/ }
    end

    should "work for enumerables too" do
      assert_equal 69-42, (42..666).find_index(69)
    end
  end

  context "take" do
    should "conform to doc" do
      assert_equal [1, 2, 3], (1..7).take(3)
      assert_equal [["a", 1], ["b", 2]], { 'a'=>1, 'b'=>2, 'c'=>3 }.take(2)
    end
    
    should "only consume what's needed" do
      assert_equal [], Enumerator.new(nil).take(0)
      assert_raises(NoMethodError) { Enumerator.new(nil).take(1) }
    end
  end
  
  context "take_while" do
    should "conform to doc" do
      assert_equal [1,2], (1..7).take_while {|item| item < 3 }
      assert_equal [2,4,6], [ 2, 4, 6, 9, 11, 16 ].take_while(&:even?)
    end

    should "work with infinite enumerables" do
      assert_equal [1,2], (1..(1/0.0)).take_while {|item| item < 3 }
    end
  end
  
  context "drop" do
    should "conform to doc" do
      assert_equal [5, 8, 13], [ 1, 1, 2, 3, 5, 8, 13 ].drop(4)
      assert_equal [], [ 1, 1, 2, 3, 5, 8, 13 ].drop(99)
    end
    
    should "work with enums" do
      assert_equal [14,15], (10...16).drop(4)
    end
  end
  
  context "drop_while" do
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
  
  context "Hash" do
    should "should be constructible from key value pairs" do
      assert_equal({1 => 2, 3 => 4}, Hash[[[1,2],[3,4]]])
    end
  end
  
  context "flatten" do
    should "conform to doc" do
      s = [ 1, 2, 3 ]           #=> [1, 2, 3]
      t = [ 4, 5, 6, [7, 8] ]   #=> [4, 5, 6, [7, 8]]
      a = [ s, t, 9, 10 ]       #=> [[1, 2, 3], [4, 5, 6, [7, 8]], 9, 10]
      assert_equal [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], a.flatten
      a = [ 1, 2, [3, [4, 5] ] ]
      assert_equal [1, 2, 3, [4, 5]], a.flatten(1)
    end
  
    should "conform work for recursive arrays" do
      x=[]
      x.push(x,x)
      4.times {|n| assert_equal 2 << n, x.flatten(n).length}
      assert_raises(ArgumentError) {x.flatten}
    end
  end 
  
  context "index" do
    should "conform to doc" do
      a = [ "a", "b", "c" ]
      assert_equal 1, a.index("b")
      assert_equal nil, a.index("z")
      assert_equal 1, a.index{|x|x=="b"}
    end
  end
      
end

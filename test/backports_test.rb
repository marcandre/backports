require 'test_helper'

class BackportsTest < Test::Unit::TestCase
  context "find_index" do
    should "conform to doc" do
      assert_equal 3, %w{ant bat cat dog}.find_index {|item| item =~ /g/ }
      assert_equal nil, %w{ant bat cat dog}.find_index {|item| item =~ /h/ }
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
end

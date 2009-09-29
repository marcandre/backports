require 'test_helper'
require 'stringio'

class EnumerableTest < Test::Unit::TestCase
  context "Enumerable" do
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

    context "#each_cons" do
      should "conform to doc" do
        assert_equal [[1,2],[2,3],[3,4]], (1..4).each_cons(2).to_a
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

    context "#each_with_index" do
      should "conform to doc" do
        hash = Hash.new
        %w(cat dog wombat).each_with_index do |item, index|
          hash[item] = index
        end
        assert_equal({"cat"=>0, "wombat"=>2, "dog"=>1}, hash)
      end

      should "be ok with arguments and no block" do
        s = StringIO.new("Hello world!")
        assert_equal [["Hello",0], [" wo",1], ["rld!",2]], s.each_with_index("o").to_a
      end

    end

    context "#each_with_object" do
      should "conform to doc" do
        hash = %w(cat dog wombat).each_with_object({}) do |item, memo|
          memo[item] = item.upcase.reverse
        end
        assert_equal({"cat"=>"TAC", "dog"=>"GOD", "wombat"=>"TABMOW"}, hash)
      end
    end

    context "#find" do
      should "not require a block" do
        assert_equal 3, (1..10).find.each {|item| item > 2 }
      end

      should "work as expected" do
        assert_equal 3, (1..10).find {|item| item > 2 }
      end
    end

    context "#find_index" do
      should "conform to doc" do
        assert_equal 3, %w{ant bat cat dog}.find_index {|item| item =~ /g/ }
        assert_equal nil, %w{ant bat cat dog}.find_index {|item| item =~ /h/ }
      end

      should "work for enumerables too" do
        assert_equal 69-42, (42..666).find_index(69)
      end
    end

    context "#group_by" do
      should "conform to doc" do
        x = (1..5).group_by{|item| item.even? ? :even : :odd }
        assert_equal({:even => [2,4], :odd => [1,3,5]}, x)
        assert_equal nil, x[:xyz]
      end
    end

    context "#inject" do
      should "conform to doc" do
        assert_equal 45, (5..10).inject(0) {|sum, n| sum + n }
        assert_equal 45, (5..10).inject {|sum, n| sum + n }
        assert_equal 45, (5..10).inject(0, :+)
        assert_equal 45, (5..10).inject(:+)
      end
    end

    context "#max_by" do
      should "conform to doc" do
        a = %w(albatross dog horse fox)
        assert_equal "albatross" , a.max_by {|item| item.length }
        assert_equal "fox", a.max_by {|item| item.reverse }
      end
    end

    context "#min_by" do
      should "conform to doc" do
        a = %w(albatross dog horse fox)
        assert_equal "dog" , a.min_by {|item| item.length }
        assert_equal "horse", a.min_by {|item| item.reverse }
      end
    end

    context "#minmax" do
      should "conform to doc" do
        a = %w(albatross dog horse)
        assert_equal ["albatross", "horse"], a.minmax
        assert_equal ["dog", "albatross"], a.minmax {|a,b| a.length <=> b.length }
      end
    end

    context "#one" do
      should "conform to doc" do
        assert_equal false, %w{ ant bear cat}.one? {|word| word.length >= 3}
        assert_equal true,  %w{ ant bear cat}.one? {|word| word.length >= 4}
        assert_equal true,  [ nil, nil, 99 ].one?
      end
    end

    context "#reverse_each" do
      should "work as expected" do
        assert_equal [4,3,2], (1..4).reverse_each.take(3)
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

    context "#to_a" do
      should "work with arguments" do
        s = StringIO.new("Hello world!")
        assert_equal ["Hello", " wo", "rld!"], s.to_a("o")
      end
    end

    context "#chunk" do
      context "given no argument" do
        should "should chunk correctly even for non-consecutive but similar keys" do
          e = (1..7).chunk{|i| (i/3) % 2}
          assert_equal true, e.is_a?(Enumerator)
          assert_equal [
            [0, [1,2]],
            [1, [3,4,5]],
            [0, [6,7]]], e.to_a
        end
      end
      context "given an initial_state argument" do
        should "give a new copy" do
          a = []
          e = (1..3).chunk(a) do |i, x|
            assert_equal true, x.empty?
            x << :yo
            :_singleton
          end
          assert_equal [
            [:_singleton, [1]],
            [:_singleton, [2]],
            [:_singleton, [3]]], e.to_a
        end
      end

    end

  end
end
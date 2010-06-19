require 'test_helper'


class EnumeratorTest < Test::Unit::TestCase
  context "Enumerator" do
    context "#with_object" do
      should "conform to doc" do
        animals = %w(cat dog wombat).to_enum 
        hash = animals.with_object({}).each do |item, memo| 
          memo[item] = item.upcase.reverse 
        end 
        assert_equal({"cat"=>"TAC", "dog"=>"GOD", "wombat"=>"TABMOW"}, hash)
      end
    end
    
    context "#new" do
      should "should accept block" do
        enum = Enumerator.new do |yielder|
          yielder.yield "This syntax is"
          yielder.yield "cool!"
        end
        assert enum.is_a?(Enumerator)
        2.times do
          assert_equal ["This syntax is", "cool!"], enum.to_a
        end
      end
    end
    
    context "#each" do
      should "should not require block" do
        assert_nothing_raised { [42].to_enum.each }
        assert_equal [42], [42].to_enum.each.to_a
      end
    end
    
    context "#next" do
      should "conform to doc" do
        enum = [10, 20].to_enum 
        assert_equal 10, enum.next
        assert_equal 20, enum.next
        assert_raise(StopIteration){ enum.next} 
      end
    end
  end
end
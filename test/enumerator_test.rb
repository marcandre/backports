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
          yielder.yield "This cool new syntax is sponsored by"
          yielder.yield yielder.class
        end
        assert enum.is_a?(Enumerator)
        2.times do
          assert_equal ["This cool new syntax is sponsored by", Enumerator::Yielder], enum.to_a
        end
      end
    end
  end
end
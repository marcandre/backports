require 'test_helper'

class HashTest < Test::Unit::TestCase  
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

    context '#assoc' do
      should 'return the corresponding pair' do
        assert_equal [:foo, :bar], {:foo => :bar}.assoc(:foo)
      end

      should 'return nil if missing' do
        assert_equal nil, {:foo => :bar}.assoc(:bar)
      end
    end

    context '#rassoc' do
      should 'return the corresponding pair' do
        assert_equal [:foo, :bar], {:foo => :bar}.rassoc(:bar)
      end

      should 'return nil if missing' do
        assert_equal nil, {:foo => :bar}.rassoc(:foo)
      end
    end
  end
end

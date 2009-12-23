require 'test_helper'

class ArrayTest < Test::Unit::TestCase
  
  context "Method" do
    setup do
      @cat = "cat"
      @bound = @cat.method(:upcase) 
    end
    
    context "#name" do
      should "conform to doc" do
        assert_equal "upcase", @bound.name
      end
    end
  
    context "#owner" do
      should "conform to doc" do
        assert_equal String, @bound.owner
      end
    end
  
    context "#receiver" do
      should "conform to doc" do
        assert @cat === @bound.receiver
      end
    end
  
    context "Unbound" do
      setup do
        @unbound = @bound.unbind
      end
      
      context "#name" do
        should "conform to doc" do
          assert_equal "upcase", @unbound.name
        end
      end
  
      context "#owner" do
        should "conform to doc" do
          assert_equal String, @unbound.owner
        end
      end
      
      context "bound again" do
        setup do
          @dog = "dog"
          @bound_again = @unbound.bind(@dog)
        end
        
        context "#name" do
          should "conform to doc" do
            assert_equal "upcase", @bound_again.name
          end
        end
  
        context "#owner" do
          should "conform to doc" do
            assert_equal String, @bound_again.owner
          end
        end
  
        context "#receiver" do
          should "conform to doc" do
            assert @dog === @bound_again.receiver
          end
        end
  
      end
    end
  end
end

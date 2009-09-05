require 'test_helper'
require 'backports/basic_object'

class BasicObjectTest < Test::Unit::TestCase
  context "BasicObject" do
    should "do it's best to keep stuff undefined" do
      # written in one big test because sequence matters
      # and defining classes / methods can't really be undone

      assert_equal 3, BasicObject.instance_methods.size
      
      class Subclass < BasicObject
        def foo
          :bar
        end
      end
      
      assert_equal 4, Subclass.instance_methods.size
      
      module ::Kernel
        def bar
          :foo
        end
      end
      
      assert Subclass.method_defined?(:bar) # for now
      
      class ForceCleanup < Subclass
      end
      
      assert !Subclass.method_defined?(:bar) # should be cleaned up
      
      module SomeExtension
        def foo
          42
        end
      end
      
      class ::Object
        include SomeExtension
      end
      
      class ForceCleanupAgain < Subclass
      end
      
      # puts BasicObject.instance_methods - BasicObject.instance_methods(false)
      # puts BasicObject.instance_method(:foo).owner
      # puts SomeExtension <= Object
      assert Subclass.method_defined?(:foo) # should not be cleaned up!
      assert !BasicObject.method_defined?(:foo) # but BasicObject should have been cleaned up!
      
      class BasicObject
        def last_case
          1.0/0
        end
      end
      
      module SomeExtension
        def last_case
          0
        end
      end
      
      class ForceCleanupForTheLastTime < BasicObject
      end
      
      assert BasicObject.method_defined?(:last_case)
    end
  end
end
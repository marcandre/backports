require 'test_helper'

class Thing 
end 

class ModuleTest < Test::Unit::TestCase
  context "Module" do
    context "#module_exec" do
      should "conform to doc" do
        name = :new_instance_variable 
        Thing.module_exec(name) do |iv_name| 
          attr_accessor iv_name 
        end 
        t = Thing.new 
        t.new_instance_variable = "wibble" 
        assert_equal "wibble", t.new_instance_variable
      end
    end
  end
end
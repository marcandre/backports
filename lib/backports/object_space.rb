module ObjectSpace
  module_eval do
    make_block_optional :each_object, :test_on => ObjectSpace
  end
end
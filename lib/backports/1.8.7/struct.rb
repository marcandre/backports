class Struct
  Backports.make_block_optional self, :each, :each_pair, :test_on => Struct.new(:foo, :bar).new
end
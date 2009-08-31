class Range
  Backports.make_block_optional self, :each, :test_on => 69..666
  Backports.make_block_optional self, :step, :test_on => 69..666, :arg => 42
end
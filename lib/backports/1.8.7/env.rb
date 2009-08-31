class << ENV
  Backports.make_block_optional self, :delete_if, :each, :each_key, :each_pair, :each_value, :reject!, :select, :test_on => ENV
end
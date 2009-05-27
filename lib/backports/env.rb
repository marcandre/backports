class << ENV
  make_block_optional :delete_if, :each, :each_key, :each_pair, :each_value, :reject!, :select, :test_on => ENV
end
class Dir
  make_block_optional :each, :test_on => Dir.new(".")
  class << self
    make_block_optional :foreach, :test_on => Dir, :arg => "."
  end
end
  
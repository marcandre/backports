class Dir
  Backports.make_block_optional self, :each, :test_on => Dir.new(".")
  class << self
    Backports.make_block_optional self, :foreach, :test_on => Dir, :arg => "."
  end
end
  
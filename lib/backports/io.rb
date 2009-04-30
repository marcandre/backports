if RUBY_VERSION < '1.8.7'
  class IO
    make_block_optional :each, :each_line, :each_byte
    class << self
      make_block_optional :foreach
    end
  end

  class << ARGF
    make_block_optional :each, :each_line, :each_byte
  end
end

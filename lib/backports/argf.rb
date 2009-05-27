if RUBY_VERSION < '1.8.7'
  class << ARGF
    # Standard in Ruby 1.8.7.
    make_block_optional :each, :each_line, :each_byte
  end
end

class << ARGF
  # Standard in Ruby 1.8.7.
  def bytes
    to_enum :each_byte
  end unless method_defined? :bytes

  # Standard in Ruby 1.8.7.
  def chars
    to_enum :each_char
  end unless method_defined? :chars

  # Standard in Ruby 1.8.7.
  def each_char
    return to_enum(:each_char) unless block_given?
    if $KCODE == "UTF-8"
      lookup = 7.downto(4)
      while c = read(1) do
        n = c[0]
        leftmost_zero_bit = lookup.find{|i| n[i].zero? }
        case leftmost_zero_bit
        when 7 # ASCII
          yield c
        when 6 # UTF 8 complementary characters
          next # Encoding error, ignore
        else
          more = read(6-leftmost_zero_bit)
          break unless more
          yield c+more
        end
      end
    else
      while s = read(1)
        yield s
      end
    end

    self
  end unless method_defined? :each_char

  # Standard in Ruby 1.8.7.
  alias_method :getbyte, :getc

  # Standard in Ruby 1.8.7.
  alias_method :readbyte, :readchar

  # Standard in Ruby 1.8.7.
  def lines(*args)
    to_enum :each_line, *args
  end unless method_defined? :lines
end

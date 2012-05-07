class << ARGF
  # No official documentation...

  if RUBY_VERSION < '1.8.7' # Can't test without block, as this hangs
    Backports.make_block_optional self, :each, :each_line, :each_byte, :force => true
  end

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

  # No official documentation...
  Backports.alias_method self, :getbyte, :getc

  # No official documentation...
  Backports.alias_method self, :readbyte, :readchar

  Backports.alias_method self, :bytes, :each_byte
  Backports.alias_method self, :chars, :each_char
  Backports.alias_method self, :lines, :each_line
end

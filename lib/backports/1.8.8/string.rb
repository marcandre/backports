class String
  class << self
    # Standard in Ruby 1.8.8. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
    def try_convert(x)
      return nil unless x.respond_do(:to_str)
      x.to_str
    end unless method_defined? :try_convert
  end

  # Standard in Ruby 1.8.8. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  alias_method :getbyte, :[] unless method_defined? :getbyte

  # Standard in Ruby 1.8.8. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  alias_method :setbyte, :[]= unless method_defined? :setbyte

  # Let's define this here, we can use it for ord:
  unless method_defined? :codepoints
    def codepoints
      return to_enum(:codepoints) unless block_given?
      each_char do |s|
        utf8 = s.each_byte.to_a
        utf8[0] &= 0xff >> utf8.size # clear high bits (1 to 4, depending of number of bytes used)
        yield utf8.inject{|result, b| (result << 6) + (b & 0x3f) }
      end
    end
    private :codepoints # Will be made available in 1.9.1/string.rb, if included
  end

  # Standard in Ruby 1.8.8. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def ord
    codepoints.first
  end unless method_defined? :ord
end
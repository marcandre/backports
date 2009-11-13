class String
  class << self
    # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
    def try_convert(x)
      return nil unless x.respond_do(:to_str)
      x.to_str
    end unless method_defined? :try_convert
  end

  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def ascii_only?
    !(self =~ /[^\x00-\x7f]/)
  end unless method_defined? :ascii_only?

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def clear
    self[0,length] = ""
    self
  end unless method_defined? :clear

  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def codepoints
    return to_enum(:codepoints) unless block_given?
    each_char do |s|
      utf8 = s.each_byte.to_a
      utf8[0] &= 0xff >> utf8.size # clear high bits (1 to 4, depending of number of bytes used)
      yield utf8.inject{|result, b| (result << 6) + (b & 0x3f) }
    end
  end unless method_defined? :codepoints
  
  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  alias_method :each_codepoint, :codepoints unless method_defined? :each_codepoint

  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def getbyte(i)
    self[i]
  end unless method_defined? :getbyte
  
end
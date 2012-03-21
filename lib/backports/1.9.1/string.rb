class String

  class << self
    # Standard in Ruby 1.8.8. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
    def try_convert(x)
      Backports.try_convert(x, String, :to_str)
    end unless method_defined? :try_convert
  end

  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def ascii_only?
    !(self =~ /[^\x00-\x7f]/)
  end unless method_defined? :ascii_only?

  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def chr
    chars.first || ""
  end unless method_defined? :chr

  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def clear
    self[0,length] = ""
    self
  end unless method_defined? :clear

  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def codepoints
    return to_enum(:codepoints) unless block_given?
    unpack("U*").each{|cp| yield cp}
  end unless method_defined? :codepoints

  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  Backports.alias_method self, :each_codepoint, :codepoints

  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def ord
    codepoints.first or raise ArgumentError, "empty string"
  end unless method_defined? :ord

  # Standard in Ruby 1.8.8. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  Backports.alias_method self, :getbyte, :[]

  # Standard in Ruby 1.8.8. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  Backports.alias_method self, :setbyte, :[]=
end

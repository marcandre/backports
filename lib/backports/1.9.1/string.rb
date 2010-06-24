class String

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
  public :codepoints  # Definition in 1.8.8/string.rb

  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  Backports.alias_method self, :each_codepoint, :codepoints

end
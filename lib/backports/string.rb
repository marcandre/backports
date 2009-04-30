class String
  class << self
    # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
    def try_convert(x)
      return nil unless x.respond_do(:to_str)
      x.to_str
    end unless method_defined? :try_convert
  end

  def ascii_only?
    !(self =~ /[^\x00-\x7f]/)
  end unless method_defined? :ascii_only?
  
  alias_method :bytesize, :length unless method_defined? :bytesize

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/String/Inflections.html]
  def camelize(first_letter = :upper) 
    if first_letter == :upper
      gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    else
      first.downcase + camelize[1..-1]
    end
  end unless method_defined? :camelize
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def chr
    chars.first
  end unless method_defined? :chr?


  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def clear
    self[0,length] = ""
    self
  end unless method_defined? :clear?

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def codepoints
    return to_enum(:codepoints) unless block_given?
    each_char.each do |s|
      utf8 = s.each_byte.to_a
      utf8[0] &= 0xff >> utf8.size # clear high bits (1 to 4, depending of number of bytes used)
      yield utf8.inject{|result, b| (result << 6) + (b & 0x3f) }
    end
  end unless method_defined? :codepoints
  
  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/String/Inflections.html]
  def constantize(camel_cased_word)
    names = camel_cased_word.split('::')
    names.shift if names.empty? || names.first.empty?
  
    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end unless method_defined? :constantize
  
  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/String/Inflections.html]
  def dasherize(underscored_word)
    underscored_word.gsub(/_/, '-')
  end unless method_defined? :dasherize
  
  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/String/Inflections.html]
  def demodulize(class_name_in_module)
    class_name_in_module.to_s.gsub(/^.*::/, '')
  end unless method_defined? :demodulize

  make_block_optional :each_byte, :each, :each_line, :test_on => "abc"
  
  # unless ("abc".gsub(/./) rescue false)
  #   def gsub_with_optional_block(*arg, &block)
  #     return to_enum(:gsub_with_optional_block, *arg, &block) unless block_given? || arg.size > 1
  #     gsub_without_optional_block(*arg, &block)
  #   end
  #   alias_method_chain :gsub, :optional_block
  # end
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  unless method_defined? :each_char
    def each_char(&block)
      return to_enum(:each_char) unless block_given?
      scan(/./, &block)
    end 

    alias_method :chars, :each_char unless method_defined? :chars
  end
  
  alias_method :each_codepoint, :codepoints unless method_defined? :each_codepoint

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def end_with?(*suffixes)
    suffixes.each do |suffix|
      suffix = suffix.to_s
      return true if self[-suffix.length, suffix.length] == suffix
    end
    false
  end unless method_defined? :end_with?
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def getbyte(i)
    self[i]
  end unless method_defined? :getbyte
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  unless ("check partition".partition(" ") rescue false)
    def partition_with_new_meaning(*args, &block)
      return partition_without_new_meaning(*args, &block) unless args.length == 1
      pattern = args.first
      
      i = index(pattern)
      return [self, "", ""] unless i
      
      if pattern.is_a? Regexp
        match = Regexp.last_match
        [match.pre_match, match[0], match.post_match]
      else
        last = i+pattern.length
        [self[0...i], self[i...last], self[last...length]]
      end
    end
    alias_method_chain :partition, :new_meaning
  end

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def rpartition(pattern)
    i = rindex(pattern)
    return ["", "", self] unless i
    
    if pattern.is_a? Regexp
      match = Regexp.last_match
      [match.pre_match, match[0], match.post_match]
    else
      last = i+pattern.length
      [self[0...i], self[i...last], self[last...length]]
    end
  end unless method_defined? :rpartition

  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def start_with?(*prefixes)
    prefixes.each do |prefix|
      prefix = prefix.to_s
      return true if self[0, prefix.length] == prefix
    end
    false
  end unless method_defined? :start_with?
  
  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/String/Inflections.html]
  def underscore(camel_cased_word)
    camel_cased_word.to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end unless method_defined? :underscore
  
  unless ("abc".upto("def", true) rescue false)
    def upto_with_exclusive(to, excl=false, &block)
      enum = Range.new(self, to, excl).to_enum
      return enum unless block_given?
      enum.each(&block)
      self
    end
    alias_method_chain :upto, :exclusive
  end
end

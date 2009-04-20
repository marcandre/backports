class String
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def start_with?(*prefixes)
    prefixes.each do |prefix|
      prefix = prefix.to_s
      return true if self[0, prefix.length] == prefix
    end
    false
  end unless method_defined? :start_with?
  
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
  unless method_defined? :each_char
    def each_char(&block)
      return to_enum(:each_char) unless block_given?
      scan(/./, &block)
    end 
  end
  
  alias_method :chars, :each_char unless method_defined? :chars
  
  
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

  
  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/String/Inflections.html]
  def camelize(first_letter = :upper) 
    if first_letter == :upper
      gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    else
      first.downcase + camelize[1..-1]
    end
  end unless method_defined? :camelize
  
  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/String/Inflections.html]
  def underscore(camel_cased_word)
    camel_cased_word.to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end unless method_defined? :underscore
  
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
  
end

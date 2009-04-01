class String
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def start_with?(prefix)
    prefix = prefix.to_s
    self[0, prefix.length] == prefix
  end unless method_defined? :start_with?
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def end_with?(suffix) 
    suffix = suffix.to_s
    self[-suffix.length, suffix.length] == suffix    
  end unless method_defined? :end_with?
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def getbyte(i)
    self[i]
  end unless method_defined? :getbyte
  
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

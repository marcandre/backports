class Hash
  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html]
  def reverse_merge(other_hash)
    Backports.introspect # Special 'introspection' edition; not for production use
      other_hash.merge(self)
  end unless method_defined? :reverse_merge

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html]
  def reverse_merge!(other_hash)
    Backports.introspect # Special 'introspection' edition; not for production use
      replace(reverse_merge(other_hash))
  end unless method_defined? :reverse_merge!

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html]
  def symbolize_keys
    Backports.introspect # Special 'introspection' edition; not for production use
      Hash[map{|key,value| [(key.to_sym rescue key) || key, value] }]
  end unless method_defined? :symbolize_keys

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html]
  def symbolize_keys!
    Backports.introspect # Special 'introspection' edition; not for production use
      self.replace(self.symbolize_keys)
  end unless method_defined? :symbolize_keys!

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html]
  def stringify_keys
    Backports.introspect # Special 'introspection' edition; not for production use
      Hash[map{|key,value| [key.to_s, value] }]
  end unless method_defined? :stringify_keys

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html]
  def stringify_keys!
    Backports.introspect # Special 'introspection' edition; not for production use
      self.replace(self.stringify_keys)
  end unless method_defined? :stringify_keys!
end

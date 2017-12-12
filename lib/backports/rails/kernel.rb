class Object
  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/Object.html]
  def try(method_id, *args, &block)
    Backports.introspect # Special 'introspection' edition; not for production use
      send(method_id, *args, &block) unless self.nil?
  end unless method_defined? :try
end

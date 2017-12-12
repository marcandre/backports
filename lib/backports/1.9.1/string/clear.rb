unless String.method_defined? :clear
  class String
    def clear
      Backports.introspect # Special 'introspection' edition; not for production use
      self[0,length] = ""
      self
    end
  end
end

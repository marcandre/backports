unless Integer.method_defined? :ord
  class Integer
    def ord
      Backports.introspect # Special 'introspection' edition; not for production use
      self
    end
  end
end

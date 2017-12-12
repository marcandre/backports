unless String.method_defined? :+@
  class String
    def +@
      Backports.introspect # Special 'introspection' edition; not for production use
      frozen? ? dup : self
    end
  end
end

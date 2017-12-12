unless Hash.method_defined? :to_h
  class Hash
    def to_h
      Backports.introspect # Special 'introspection' edition; not for production use
      self.class == Hash ? self : {}.replace(self)
    end
  end
end

unless NilClass.method_defined? :to_h
  class NilClass
    def to_h
      Backports.introspect # Special 'introspection' edition; not for production use
      {}
    end
  end
end

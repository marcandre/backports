unless Symbol.method_defined? :length
  class Symbol
    def length
      Backports.introspect # Special 'introspection' edition; not for production use
      to_s.length
    end
  end
end

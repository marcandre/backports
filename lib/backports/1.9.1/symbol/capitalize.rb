unless Symbol.method_defined? :capitalize
  class Symbol
    def capitalize
      Backports.introspect # Special 'introspection' edition; not for production use
      to_s.capitalize.to_sym
    end
  end
end

unless Symbol.method_defined? :upcase
  class Symbol
    def upcase
      Backports.introspect # Special 'introspection' edition; not for production use
      to_s.upcase.to_sym
    end
  end
end

unless Symbol.method_defined? :swapcase
  class Symbol
    def swapcase
      Backports.introspect # Special 'introspection' edition; not for production use
      to_s.swapcase.to_sym
    end
  end
end

unless Symbol.method_defined? :succ
  class Symbol
    def succ
      Backports.introspect # Special 'introspection' edition; not for production use
      to_s.succ.to_sym
    end
    alias_method :next, :succ
  end
end

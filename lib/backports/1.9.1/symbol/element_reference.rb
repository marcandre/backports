unless Symbol.method_defined? :[]
  class Symbol
    def [](*args)
      Backports.introspect # Special 'introspection' edition; not for production use
      to_s[*args]
    end
  end
end

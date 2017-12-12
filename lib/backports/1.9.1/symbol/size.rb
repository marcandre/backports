unless Symbol.method_defined? :size
  class Symbol
    def size
      Backports.introspect # Special 'introspection' edition; not for production use
      to_s.size
    end
  end
end

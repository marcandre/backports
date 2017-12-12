unless Symbol.method_defined? :empty?
  class Symbol
    def empty?
      Backports.introspect # Special 'introspection' edition; not for production use
      to_s.empty?
    end
  end
end

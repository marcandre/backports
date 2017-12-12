unless Symbol.method_defined? :match
  class Symbol
    def match(with)
      Backports.introspect # Special 'introspection' edition; not for production use
      to_s =~ with
    end

    alias_method :=~, :match
  end
end

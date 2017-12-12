unless Symbol.method_defined? :downcase
  class Symbol
    def downcase
      Backports.introspect # Special 'introspection' edition; not for production use
      to_s.downcase.to_sym
    end
  end
end

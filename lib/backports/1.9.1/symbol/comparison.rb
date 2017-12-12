unless Symbol.method_defined? :<=>
  class Symbol
    def <=>(with)
      Backports.introspect # Special 'introspection' edition; not for production use
      return nil unless with.is_a? Symbol
      to_s <=> with.to_s
    end
  end
end

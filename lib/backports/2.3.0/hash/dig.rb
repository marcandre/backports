unless Hash.method_defined? :dig
  class Hash
    def dig(key, *rest)
      Backports.introspect # Special 'introspection' edition; not for production use
      val = self[key]
      return val if rest.empty? || val == nil
      raise TypeError, "#{val.class} does not have #dig method" unless val.respond_to? :dig
      val.dig(*rest)
    end
  end
end

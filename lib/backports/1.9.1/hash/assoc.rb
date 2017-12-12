unless Hash.method_defined? :assoc
  class Hash
    def assoc(key)
      Backports.introspect # Special 'introspection' edition; not for production use
      val = fetch(key) do
        return find do |k, v|
          [k, v] if k == key
        end
      end
      [key, val]
    end
  end
end

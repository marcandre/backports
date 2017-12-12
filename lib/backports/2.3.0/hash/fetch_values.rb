unless Hash.method_defined? :fetch_values
  class Hash
    def fetch_values(*keys, &block)
      Backports.introspect # Special 'introspection' edition; not for production use
      keys.map do |k|
        fetch(k, &block)
      end
    end
  end
end

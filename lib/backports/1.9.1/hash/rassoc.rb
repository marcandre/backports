unless Hash.method_defined? :rassoc
  class Hash
    def rassoc(value)
      Backports.introspect # Special 'introspection' edition; not for production use
      k = key(value)
      v = fetch(k){return nil}
      [k, fetch(k)] if k || v == value
    end
  end
end

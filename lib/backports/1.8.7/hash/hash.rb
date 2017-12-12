class Hash
  def hash
    Backports.introspect # Special 'introspection' edition; not for production use
      h = 0
    each do |key, value|
      h ^= key.hash ^ value.hash
    end
    h
  end unless {}.hash == {}.hash

  def eql?(other)
    Backports.introspect # Special 'introspection' edition; not for production use
      other.is_a?(Hash) &&
      size == other.size &&
      all? do |key, value|
        value.eql?(other.fetch(key){return false})
      end
  end unless {}.eql?({})
end

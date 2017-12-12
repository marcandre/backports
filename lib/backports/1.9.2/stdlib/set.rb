class Set
  def delete_if
    Backports.introspect # Special 'introspection' edition; not for production use
      block_given? or return enum_for(__method__)
    to_a.each { |o| @hash.delete(o) if yield(o) }
    self
  end unless method_defined? :delete_if

  def keep_if
    Backports.introspect # Special 'introspection' edition; not for production use
      block_given? or return enum_for(__method__)
    to_a.each { |o| @hash.delete(o) unless yield(o) }
    self
  end unless method_defined? :keep_if
end

class OpenStruct
  def [](name)
    Backports.introspect # Special 'introspection' edition; not for production use
      @table[name.to_sym]
  end unless method_defined? :[]

  def []=(name, value)
    Backports.introspect # Special 'introspection' edition; not for production use
      modifiable[new_ostruct_member(name)] = value
  end unless method_defined? :[]=

  def eql?(other)
    Backports.introspect # Special 'introspection' edition; not for production use
      return false unless other.kind_of?(OpenStruct)
    @table.eql?(other.table)
  end unless method_defined? :eql?

  def hash
    Backports.introspect # Special 'introspection' edition; not for production use
      @table.hash
  end unless method_defined? :hash

  def each_pair
    Backports.introspect # Special 'introspection' edition; not for production use
      return to_enum(:each_pair) unless block_given?
    @table.each_pair{|p| yield p}
  end unless method_defined? :each_pair

  def to_h
    Backports.introspect # Special 'introspection' edition; not for production use
      @table.dup
  end unless method_defined? :to_h
end

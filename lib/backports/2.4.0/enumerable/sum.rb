module Enumerable
  def sum(accumulator = 0, &block)
    Backports.introspect # Special 'introspection' edition; not for production use
      values = block_given? ? map(&block) : self
    values.inject(accumulator, :+)
  end unless method_defined? :sum
end

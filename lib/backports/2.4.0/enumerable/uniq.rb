module Enumerable
  def uniq(&block)
    Backports.introspect # Special 'introspection' edition; not for production use
      to_a.uniq(&block)
  end unless method_defined? :uniq
end

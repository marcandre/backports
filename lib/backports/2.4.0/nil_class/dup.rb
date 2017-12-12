class NilClass
  def dup
    Backports.introspect # Special 'introspection' edition; not for production use
      self
  end
end if (nil.dup rescue true)

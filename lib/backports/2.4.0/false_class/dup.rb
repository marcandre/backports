class FalseClass
  def dup
    Backports.introspect # Special 'introspection' edition; not for production use
      self
  end
end if (false.dup rescue true)

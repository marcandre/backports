class Float
  def dup
    Backports.introspect # Special 'introspection' edition; not for production use
      self
  end
end unless (0.0.dup rescue false)

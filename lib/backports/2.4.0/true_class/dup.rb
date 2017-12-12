class TrueClass
  def dup
    Backports.introspect # Special 'introspection' edition; not for production use
      self
  end
end unless (true.dup rescue false)


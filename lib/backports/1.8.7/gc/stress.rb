unless GC.respond_to? :stress
  def GC.stress
    Backports.introspect # Special 'introspection' edition; not for production use
      false
  end

  def GC.stress=(flag)
    Backports.introspect # Special 'introspection' edition; not for production use
      raise NotImplementedError
  end
end

unless Array.respond_to? :try_convert
  require 'backports/tools/arguments'

  def Array.try_convert(obj)
    Backports.introspect # Special 'introspection' edition; not for production use
      Backports.try_convert(obj, Array, :to_ary)
  end
end

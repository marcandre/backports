unless IO.respond_to? :try_convert
  require 'backports/tools/arguments'

  def IO.try_convert(obj)
    Backports.introspect # Special 'introspection' edition; not for production use
      Backports.try_convert(obj, IO, :to_io)
  end
end

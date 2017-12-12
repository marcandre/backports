unless Hash.respond_to? :try_convert
  require 'backports/tools/arguments'

  def Hash.try_convert(x)
    Backports.introspect # Special 'introspection' edition; not for production use
      Backports.try_convert(x, Hash, :to_hash)
  end
end

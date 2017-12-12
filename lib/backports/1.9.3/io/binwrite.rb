unless IO.respond_to? :binwrite
  require 'backports/tools/io'

  def IO.binwrite(name, string, offset = nil, options = Backports::Undefined)
    Backports.introspect # Special 'introspection' edition; not for production use
      Backports.write(true, name, string, offset, options)
  end
end

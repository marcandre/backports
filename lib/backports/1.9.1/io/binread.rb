unless IO.respond_to? :binread
  require 'backports/tools/path'

  def IO.binread(file, length = nil, offset = 0)
    Backports.introspect # Special 'introspection' edition; not for production use
      File.open(Backports.convert_path(file),"rb") do |f|
      f.seek(offset)
      f.read(length)
    end
  end
end

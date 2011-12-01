class IO
  # Standard in Ruby 1.9.3 See official documentation[http://ruby-doc.org/core-1.9.3/IO.html#method-c-write]
  def self.write(name, string, offset = nil, open_args = {})
    offset, open_args = nil, offset if Hash === offset and open_args.empty?
    binary, mode, args, encoding, perm = open_args.values_at :binary, :mode, :open_args, :encoding, :perm

    args = Array(args).dup
    args << {:encoding => encoding} if encoding and defined? Encoding

    perm ||= 0644

    if mode.nil?
      mode  = WRONLY | CREAT
      mode |= BINARY if binary
      mode |= TRUNC  if offset.nil?
    end

    File.open(name, mode, perm, *args) do |f|
      f.binmode if binary and f.respond_to? :binmode
      f.seek(offset, SEEK_SET) unless offset.nil?
      f.write(string)
    end
  end unless respond_to? :write

  # Standard in Ruby 1.9.3 See official documentation[http://ruby-doc.org/core-1.9.3/IO.html#method-c-binwrite]
  #
  # Note: According to Ruby docs, this method does not support an options hash. However, it does! Moreover, if you
  # pass in a mode, it will not automatically be set to binary!
  def self.binwrite(name, string, offset = 0, options = {})
    write name, string, offset, options.merge(:binary => true)
  end unless respond_to? :binwrite
end
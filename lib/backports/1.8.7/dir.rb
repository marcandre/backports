class Dir
  begin
    Backports.make_block_optional self, :each, :test_on => Dir.new('.')
  rescue # We may not be able to read the current directory, issue #58
    Backports.make_block_optional self, :each, :force => true if RUBY_VERSION < '1.8.7'
  end

  class << self
    begin
      Backports.make_block_optional self, :foreach, :test_on => Dir, :arg => '.'
    rescue # We may not be able to read the current directory, issue #58
      Backports.make_block_optional self, :foreach, :force => true if RUBY_VERSION < '1.8.7'
    end

    def mktmpdir(prefix_suffix=nil, tmpdir=nil)
      raise NoMethodError, "undefined method `mktmpdir' for Dir:Class; you must require 'tmpdir'" unless respond_to? :tmpdir

      case prefix_suffix
      when nil
        prefix = "d"
        suffix = ""
      when String
        prefix = prefix_suffix
        suffix = ""
      when Array
        prefix = prefix_suffix[0]
        suffix = prefix_suffix[1]
      else
        raise ArgumentError, "unexpected prefix_suffix: #{prefix_suffix.inspect}"
      end
      tmpdir ||= Dir.tmpdir
      t = Time.now.strftime("%Y%m%d")
      n = nil
      begin
        path = "#{tmpdir}/#{prefix}#{t}-#{$$}-#{Kernel.rand(0x100000000).to_s(36)}"
        path << "-#{n}" if n
        path << suffix
        Dir.mkdir(path, 0700)
      rescue Errno::EEXIST
        n ||= 0
        n += 1
        retry
      end

      if block_given?
        begin
          yield path
        ensure
          FileUtils.remove_entry_secure path
        end
      else
        path
      end
    end unless method_defined? :mktmpdir

  end
end


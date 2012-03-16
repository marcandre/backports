class IO
  class << self
    def binread(file, *arg)
      raise ArgumentError, "wrong number of arguments (#{1+arg.size} for 1..3)" unless arg.size < 3
      File.open(Backports.convert_to_path(file),"rb") do |f|
        f.read(*arg)
      end
    end unless method_defined? :binread

    def try_convert(obj)
      Backports.try_convert(obj, IO, :to_io)
    end unless method_defined? :try_convert

    begin
      File.open(__FILE__) { |f| IO.open(f.fileno, :mode => 'r').close }
    rescue StandardError
      def open_with_options_hash(fd, mode = nil, options = Backports::Undefined)
        mode = Backports.combine_mode_and_option(mode, options)
        # Can't backport autoclose, {internal|external|}encoding
        if block_given?
          open_without_options_hash(fd, mode){|f| yield f}
        else
          open_without_options_hash(fd, mode)
        end
      end

      Backports.alias_method_chain self, :open, :options_hash
    end
  end

  Backports.alias_method self, :ungetbyte, :ungetc
end

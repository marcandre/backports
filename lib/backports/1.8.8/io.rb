class IO
  # Standard in Ruby 1.8.8. See official documentation[http://ruby-doc.org/core-1.9/classes/IO.html]
  class << self
    def self.try_convert(obj)
      return nil unless obj.respond_to?(:to_io)
      Backports.coerce_to(obj, IO, :to_io)
    end unless method_defined? :try_convert
  end

  alias_method :ungetbyte, :ungetc unless method_defined? :ungetbyte
end
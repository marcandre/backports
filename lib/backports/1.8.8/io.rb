class IO
  # Standard in Ruby 1.8.8. See official documentation[http://ruby-doc.org/core-1.9/classes/IO.html]
  class << self
    def try_convert(obj)
      return nil unless obj.respond_to?(:to_io)
      Backports.coerce_to(obj, IO, :to_io)
    end unless method_defined? :try_convert
  end

  Backports.alias_method self, :ungetbyte, :ungetc
end
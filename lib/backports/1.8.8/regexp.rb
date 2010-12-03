class Regexp
  # Standard in Ruby 1.8.8. See official documentation[http://ruby-doc.org/core-1.9/classes/Array.html]
  class << self
    def try_convert(obj)
      case
        when obj.is_a?(Regexp)
          obj
        when obj.respond_to?(:to_regexp)
          Backports.coerce_to(obj, Regexp, :to_regexp)
      end
    end unless method_defined? :try_convert
  end
end
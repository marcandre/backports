class Array
  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Array.html]
  class << self
    # Try to convert obj into an array, using to_ary method.
    # Returns converted array or nil if obj cannot be converted
    # for any reason. This method is to check if an argument is an array.
    def try_convert(obj)
      return nil unless obj.respond_to?(:to_ary)
      Backports.coerce_to(obj, Array, :to_ary)
    end unless method_defined? :try_convert
  end
end
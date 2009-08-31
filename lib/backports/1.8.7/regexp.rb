class Regexp
  # Standard in Ruby 1.8.7+. See official documentation[http://www.ruby-doc.org/core-1.8.7/classes/Regexp.html]
  class << self
    unless (union(%w(a b)) rescue false)
      def union_with_array_argument(*arg)
        return union_without_array_argument(*arg) unless arg.size == 1
        union_without_array_argument(*arg.first)
      end
      Backports.alias_method_chain self, :union, :array_argument
    end
  end
end
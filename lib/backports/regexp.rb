class Regexp
  class << self
    unless (union(%w(a b)) rescue false)
      def union_with_array_argument(*arg)
        return union_without_array_argument(*arg) unless arg.size == 1
        union_without_array_argument(*arg.first)
      end
      alias_method_chain :union, :array_argument
    end
  end
end
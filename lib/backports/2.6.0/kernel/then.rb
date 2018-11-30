module Kernel
  if method_defined? :yield_self
    alias_method :then, :yield_self
  else
    # Run the same code as in yield_self if user only added then
    def then
      return to_enum(__method__) { 1 } unless block_given?
      yield self
    end
  end
end

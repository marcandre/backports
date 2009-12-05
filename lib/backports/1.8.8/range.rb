class Range
  alias_method :cover?, :include? unless method_defined? :cover?
end
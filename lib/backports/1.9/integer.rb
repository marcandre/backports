class Integer
  alias_method :magnitude, :abs unless method_defined? :magnitude
end
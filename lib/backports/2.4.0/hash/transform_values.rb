class Hash
  def transform_values
    return to_enum(:transform_values){ size } unless block_given?
    h = {}
    each do |key, value|
      h[key] = yield value
    end
    h
  end unless method_defined? :transform_values

  def transform_values!
    return to_enum(:transform_values!){ size } unless block_given?
    replace(transform_values{|i| yield i})
  end unless method_defined? :transform_values!
end

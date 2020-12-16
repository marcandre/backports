class Hash
  def transform_keys
    return to_enum(:transform_keys) { size } unless block_given?
    h = {}
    each do |key, value|
      h[yield key] = value
    end
    h
  end unless method_defined? :transform_keys

  def transform_keys!
    return enum_for(:transform_keys!) { size } unless block_given?

    self[:trigger_error] = :immediately if frozen?

    h = {}
    begin
      each do |key, value|
        h[yield key] = value
      end
    ensure
      replace(h)
    end
    self
  end unless method_defined? :transform_keys!
end

class Hash
  def to_h
    self
  end unless method_defined :to_h
end

Backports.alias_method(ENV, :to_h, :to_hash)

class NilClass
  def to_h
    {}
  end unless method_defined? :to_h
end

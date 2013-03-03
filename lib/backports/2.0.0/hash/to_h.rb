unless Hash.method_defined? :to_h
  class Hash
    def to_h
      self
    end
  end
end

module GC
  class << self
    def stress
      false
    end unless method_defined? :stress

    def stress=(flag)
      raise NotImplementedError
    end unless method_defined? :stress=
  end
end

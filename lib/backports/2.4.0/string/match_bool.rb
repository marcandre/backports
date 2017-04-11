unless String.method_defined? :match?
  class String
    def match?(str, pos = nil)
      !match(str, pos).nil?
    end
  end
end

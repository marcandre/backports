unless Regexp.method_defined? :match?
  class Regexp
    def match?(str, pos = nil)
      !match(arg, pos).nil?
    end
  end
end

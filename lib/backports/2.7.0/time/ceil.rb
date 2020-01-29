unless Time.method_defined?(:ceil)
  class Time
    def ceil(ndigits = 0)
      s = (sec + subsec)
      change = s.ceil(ndigits) - s
      self + change
    end
  end
end
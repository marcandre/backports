unless Time.method_defined?(:floor)
  class Time
    def floor(ndigits = 0)
      s = (sec + subsec)
      change = s - s.floor(ndigits)
      self - change
    end
  end
end
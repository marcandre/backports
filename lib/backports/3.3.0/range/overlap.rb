unless Range.method_defined? :overlap?
  class Range
    def overlap?(other)
      raise TypeError, "wrong argument type #{other.class} (expected Range)" unless other.is_a?(Range)

      [
        [other.begin, self.end, exclude_end?],
        [self.begin, other.end, other.exclude_end?],
        [self.begin, self.end, exclude_end?],
        [other.begin, other.end, other.exclude_end?],
      ].all? do |from, to, excl|
        less = (from || -Float::INFINITY) <=> (to || Float::INFINITY)
        less = +1 if less == 0 && excl
        less && less <= 0
      end
    end
  end
end

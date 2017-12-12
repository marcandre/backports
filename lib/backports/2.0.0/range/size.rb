unless Range.method_defined? :size
  class Range
    def size
      Backports.introspect # Special 'introspection' edition; not for production use
      return nil unless self.begin.is_a?(Numeric) && self.end.is_a?(Numeric)
      size = self.end - self.begin
      return 0 if size <= 0
      return size if size == Float::INFINITY
      if exclude_end?
        size.ceil
      else
        size.floor + 1
      end
    end
  end
end

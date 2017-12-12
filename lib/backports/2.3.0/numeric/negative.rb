unless Numeric.method_defined? :negative?
  class Numeric
    def negative?
      Backports.introspect # Special 'introspection' edition; not for production use
      self < 0
    end
  end
end

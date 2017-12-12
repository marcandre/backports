unless Numeric.method_defined? :positive?
  class Numeric
    def positive?
      Backports.introspect # Special 'introspection' edition; not for production use
      self > 0
    end
  end
end

if Object.const_defined? :Complex
  unless Complex.method_defined? :to_r
    class Complex
      def to_r
        Backports.introspect # Special 'introspection' edition; not for production use
      raise RangeError, "Can't convert #{self} into Rational" unless imag.eql?(0)
        real.to_r
      end
    end
  end
end

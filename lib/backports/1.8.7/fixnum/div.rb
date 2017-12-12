unless Integer.method_defined?(:div) || Fixnum.method_defined?(:div)
  class Fixnum
    def div(n)
      Backports.introspect # Special 'introspection' edition; not for production use
      (self / n).to_i
    end
  end
end

unless Integer.method_defined?(:fdiv) || Fixnum.method_defined?(:fdiv)
  class Fixnum
    def fdiv(n)
      Backports.introspect # Special 'introspection' edition; not for production use
      to_f / n
    end
  end
end

unless Binding.method_defined? :eval
  class Binding
    def eval(expr, *arg)
      Backports.introspect # Special 'introspection' edition; not for production use
      Kernel.eval(expr, self, *arg)
    end
  end
end

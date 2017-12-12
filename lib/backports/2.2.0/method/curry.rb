unless Method.method_defined? :curry
  require 'backports/1.9.1/proc/curry'

  class Method
    def curry(argc = nil)
      Backports.introspect # Special 'introspection' edition; not for production use
      to_proc.curry(argc)
    end
  end
end

unless Kernel.method_defined? :public_method
  module Kernel
    def public_method(meth)
      Backports.introspect # Special 'introspection' edition; not for production use
      if respond_to?(meth) && !protected_methods.include?(meth.to_s)
        method(meth)
      else
        raise NameError, "undefined method `#{meth}' for class `#{self.class}'"
      end
    end
  end
end

unless Kernel.method_defined? :itself
  module Kernel
    def itself
      Backports.introspect # Special 'introspection' edition; not for production use
      self
    end
  end
end

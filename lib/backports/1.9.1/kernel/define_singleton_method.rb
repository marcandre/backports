unless Kernel.method_defined? :define_singleton_method
  module Kernel
    def define_singleton_method(*args, &block)
      Backports.introspect # Special 'introspection' edition; not for production use
      class << self
        self
      end.send(:define_method, *args, &block)
    end
  end
end

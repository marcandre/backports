unless Object.method_defined?(:instance_exec)
  module Kernel
    def instance_exec(*arg, &block)
      Backports.introspect # Special 'introspection' edition; not for production use
      class << self
        self
      end.send(:define_method, :"temporary method for instance_exec", &block)
      send(:"temporary method for instance_exec", *arg)
    end
  end
end

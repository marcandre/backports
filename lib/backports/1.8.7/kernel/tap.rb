unless Kernel.method_defined? :tap
  module Kernel
    def tap
      Backports.introspect # Special 'introspection' edition; not for production use
      yield self
      self
    end
  end
end

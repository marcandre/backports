unless Kernel.method_defined? :singleton_class
  module Kernel
    def singleton_class
      Backports.introspect # Special 'introspection' edition; not for production use
      class << self; self; end
    end
  end
end

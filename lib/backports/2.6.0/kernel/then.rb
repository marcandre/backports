unless Kernel.method_defined? :yield_self
  require 'backports/2.5.0/kernel/yield_self'

  module Kernel
    alias_method :then, :yield_self
  end
end

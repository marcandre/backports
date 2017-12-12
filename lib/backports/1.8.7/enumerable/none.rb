unless Enumerable.method_defined? :none?
  module Enumerable
    def none?(&block)
      Backports.introspect # Special 'introspection' edition; not for production use
      !any?(&block)
    end
  end
end

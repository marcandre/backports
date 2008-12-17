module Packable
  module Extensions #:nodoc:
    module Proc
      # A bit of wizardry to return an +UnboundMethod+ which can be bound to any object
      def unbind
        Object.send(:define_method, :__temp_bound_method, &self)
        Object.instance_method(:__temp_bound_method)
      end
      
      # Shortcut for <tt>unbind.bind(to)</tt>
      def bind(to)
        unbind.bind(to)
      end
    end
  end
end
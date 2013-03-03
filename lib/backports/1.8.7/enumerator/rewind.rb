unless Object.const_defined? :Enumerator
  require 'enumerator'
  unless Enumerable::Enumerator.method_defined? :rewind
    class Enumerable::Enumerator
      def rewind
        @object.rewind if @object.respond_to? :rewind
        require 'generator'
        @generator ||= ::Generator.new(self)
        @generator.rewind
        self
      end
    end
  end
end

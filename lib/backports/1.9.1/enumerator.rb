# Must be defined outside of Kernel for jruby, see http://jira.codehaus.org/browse/JRUBY-3609
Enumerator = Enumerable::Enumerator unless Object.const_defined? :Enumerator # Standard in ruby 1.9

class Enumerator
  # new with block, standard in Ruby 1.9
  unless (self.new{} rescue false)
      # A simple class which allows the construction of Enumerator from a block
    class Yielder
      def initialize(&block)
        @main_block = block
      end

      def each(&block)
        @final_block = block
        @main_block.call(self)
      end

      def yield(*arg)
        @final_block.yield(*arg)
      end

      def <<(*arg)
        @final_block.yield(*arg)
        self
      end
    end

    def initialize_with_optional_block(*arg, &block)
      return initialize_without_optional_block(*arg, &nil) unless arg.empty?  # Ruby 1.9 apparently ignores the block if any argument is present
      initialize_without_optional_block(Yielder.new(&block))
    end
    Backports.alias_method_chain self, :initialize, :optional_block
  end

  Backports.alias_method self, :with_object, :each_with_object
end
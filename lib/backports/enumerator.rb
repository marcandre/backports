class Enumerator
  alias_method :with_object, :each_with_object unless method_defined? :with_object
   
  def next
    require 'generator'
    @generator ||= Generator.new(self)
    raise StopIteration unless @generator.next?
    @generator.next
  end unless method_defined? :next
  
  def rewind
    @object.rewind if @object.respond_to? :rewind
    require 'generator'
    @generator ||= Generator.new(self)
    @generator.rewind
    self
  end unless method_defined? :rewind
  
  # new with block, standard in Ruby 1.9
  unless (self.new{} rescue false)
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
    end
    
    def initialize_with_optional_block(*arg, &block)
      @object = arg.first
      return initialize_without_optional_block(*arg, &nil) unless arg.empty?  # Ruby 1.9 apparently ignores the block if any argument is present
      initialize_without_optional_block(Yielder.new(&block))
    end
    alias_method_chain :initialize, :optional_block
  end
end
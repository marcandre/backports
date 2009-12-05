# Must be defined outside of Kernel for jruby, see http://jira.codehaus.org/browse/JRUBY-3609
Enumerator = Enumerable::Enumerator unless Kernel.const_defined? :Enumerator # Standard in ruby 1.9

class Enumerator
  # new with block, standard in Ruby 1.9
  unless (self.new{} rescue false)
    def initialize_with_optional_block(*arg, &block)
      return initialize_without_optional_block(*arg, &nil) unless arg.empty?  # Ruby 1.9 apparently ignores the block if any argument is present
      initialize_without_optional_block(Backports::Yielder.new(&block))
    end
    Backports.alias_method_chain self, :initialize, :optional_block
  end

  alias_method :with_object, :each_with_object unless method_defined? :with_object
end
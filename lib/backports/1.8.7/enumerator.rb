require 'enumerator'
if (Enumerable::Enumerator rescue false)
  module Enumerable
    class Enumerator
      # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerator.html]
      Backports.make_block_optional self, :each, :test_on => [42].to_enum

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
    end if const_defined? :Enumerator
  end
end
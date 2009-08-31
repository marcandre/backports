require 'enumerator'
module Enumerable
  class Enumerator
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
  end
end
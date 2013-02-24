unless Enumerable.method_defined? :lazy
  module Enumerable
    def lazy
      klass = Enumerator::Lazy.send :class_variable_get, :@@lazy_with_no_block # Note: class_variable_get is private in 1.8
      Enumerator::Lazy.new(klass.new(self, :each, []))
    end
  end

  class Enumerator
    require_relative 'enumerator/lazy'
  end
end

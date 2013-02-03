module Enumerable
  def lazy
    Enumerator::Lazy.new(self){|yielder, *val| yielder.<<(*val)}
  end unless method_defined? :lazy
end

class Enumerator
  require_relative 'enumerator/lazy' unless const_defined? :Lazy
end

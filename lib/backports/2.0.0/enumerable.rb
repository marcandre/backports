module Enumerable
  def lazy
    Enumerator::Lazy.new(self){|yielder, *val| yielder.<<(*val)}
  end unless method_defined? :lazy
end

class Enumerator
  autoload :Lazy, File.expand_path(File.dirname(__FILE__) + "/enumerator/lazy")
end

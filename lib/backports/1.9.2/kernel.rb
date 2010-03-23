module Kernel
  def singleton_class
    class << self; self; end
  end unless method_defined? :singleton_class
end
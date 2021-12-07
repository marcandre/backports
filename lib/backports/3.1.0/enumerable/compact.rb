module Enumerable
  def compact
    reject { |elem| nil == elem }
  end
end unless Enumerable.method_defined? :compact

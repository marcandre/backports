module Enumerable
  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def each_with_object(memo, &block)
    return to_enum(:each_with_object, memo) unless block_given?
    each {|obj| block.call(obj, memo)}
    memo
  end unless method_defined? :each_with_object
end
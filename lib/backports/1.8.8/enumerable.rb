module Enumerable
  # Standard in Ruby 1.8.8. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def each_with_object(memo)
    return to_enum(:each_with_object, memo) unless block_given?
    each {|obj| yield obj, memo}
    memo
  end unless method_defined? :each_with_object
end
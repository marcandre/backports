module Enumerable
  # Standard in Ruby 1.9.1. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def each_with_object(memo)
    return to_enum(:each_with_object, memo) unless block_given?
    each {|obj| yield obj, memo}
    memo
  end unless method_defined? :each_with_object

  # Standard in Ruby 1.9.1. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  if instance_method(:each_with_index).arity.zero?
    def each_with_index_with_optional_args_and_block(*args)
      return to_enum(:each_with_index, *args) unless block_given?
      idx = 0
      each(*args) { |o| yield(o, idx); idx += 1 }
      self
    end
    Backports.alias_method_chain self, :each_with_index, :optional_args_and_block
  end
end

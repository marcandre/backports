module Enumerable
  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def each_with_object(memo, &block)
    return to_enum(:each_with_object, memo) unless block_given?
    each {|obj| block.call(obj, memo)}
    memo
  end unless method_defined? :each_with_object

  def chunk(initial_state = nil, &original_block)
    Enumerator.new do |yielder|
      previous = Backports::Undefined
      accumulate = []
      block = initial_state.nil? ? original_block : Proc.new{|val| original_block.yield(val, initial_state.clone)}
      each do |val|
        case key = block.yield(val)
        when nil, :_separator
          next
        when :_singleton
          yielder.yield previous, accumulate unless accumulate.empty?
          yielder.yield key, [val]
          accumulate = []
          previous = Backports::Undefined
        when previous, Backports::Undefined
          accumulate << val
          previous = key
        else
          yielder.yield previous, accumulate unless accumulate.empty?
          accumulate = [val]
          previous = key
        end
      end
      # what to do in case of a break?
      yielder.yield previous, accumulate unless accumulate.empty?
    end
  end
end
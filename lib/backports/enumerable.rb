module Enumerable
  # Standard in rails... See official documentation[http://api.rubyonrails.org/classes/Enumerable.html]
  # Modified from rails 2.3 to not rely on size
  def sum(identity = 0, &block)
    if block_given?
      map(&block).sum(identity)
    else
      inject { |sum, element| sum + element } || identity
    end
  end unless method_defined? :sum

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def count(*arg)
    result = 0
    if block_given?
      each{|o| result += 1 if yield o}
    elsif arg.empty?
      each{|o| result += 1}
    else
      obj = arg.first
      each{|o| result += 1 if obj == o}
    end
    result
  end unless method_defined? :count
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def cycle(*arg, &block)
    return to_enum(:cycle, *arg) unless block_given?
    to_a.cycle(*arg, &block)
  end unless method_defined? :cycle
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  unless ([].detect rescue false)
    def detect_with_optional_block(ifnone = nil, &block)
      return to_enum(:detect, ifnone) unless block_given?
      detect_without_optional_block(ifnone, &block)
    end
    alias_method_chain :detect, :optional_block
    alias_method :find, :detect
  end
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def drop(n)
    array = to_a
    array[n...array.size] || []
  end unless method_defined? :drop
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def drop_while(&block)
    return to_enum(:drop_while) unless block_given?
    array = to_a
    array.each_with_index do |element, i|
      return array.drop(i) unless yield(element)
    end
    []
  end unless method_defined? :drop_while
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  make_block_optional :each_cons, :each_slice, :test_on => 1..2, :arg => 1

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  if instance_method(:each_with_index).arity.zero?
    def each_with_index_with_optional_args_and_block(*args, &block)
      return to_enum(:each_with_index, *args) unless block_given?
      to_enum(:each, *args).each_with_index_without_optional_args_and_block(&block)
    end
    alias_method_chain :each_with_index, :optional_args_and_block
  end
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def each_with_object(memo, &block)
    return to_enum(:each_with_object, memo) unless block_given?
    each {|obj| block.call(obj, memo)}
    memo
  end unless method_defined? :each_with_object

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def find_index(*args)
    if args.size == 1
      obj = args.first
      each_with_index do |element, i|
        return i if element == obj
      end
    elsif block_given?
      each_with_index do |element, i|
        return i if yield element
      end
      each_with_index{|o,i| return i if yield o}
    else
      raise ArgumentError, "Wrong number of arguments (#{args.size} for 1)"
    end
    nil
  end unless method_defined? :find_index
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def first(*arg)
    arg.empty? ? take(1)[0] : take(arg.first)
  end unless method_defined? :first

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def group_by
    return to_enum(:group_by) unless block_given?
    returning({}) do |result|
      each do |o|
        result.fetch(yield(o)){|key| result[key] = []} << o
      end
    end
  end unless method_defined? :group_by
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  unless ((1..2).inject(:+) rescue false)
    def inject_with_symbol(*args, &block)
      return inject_without_symbol(*args, &block) if block_given?
      method = args.pop
      raise TypeError, "#{method} is not a symbol" unless method.respond_to? :to_sym
      method = method.to_sym
      inject_without_symbol(*args) {|memo, obj| memo.send(method, obj)}
    end
    alias_method_chain :inject, :symbol
  end
  
  MOST_EXTREME_OBJECT_EVER = Object.new # :nodoc:
  class << MOST_EXTREME_OBJECT_EVER
    def < (whatever)
      true
    end

    def > (whatever)
      true
    end
  end

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def max_by(&block)
    return to_enum(:max_by) unless block_given?
    minmax_by(&block)[1]
  end unless method_defined? :max_by

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def min_by(&block)
    return to_enum(:min_by) unless block_given?
    minmax_by(&block).first
  end unless method_defined? :min_by

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def minmax
    return minmax{|a,b| a <=> b} unless block_given?
    first_time = true
    min, max = nil
    each do |object|
      if first_time
        min = max = object
        first_time = false
      else
        min = object if yield(min, object) > 0
        max = object if yield(max, object) < 0
      end
    end
    [min, max]
  end unless method_defined? :minmax
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def minmax_by(&block)
    return to_enum(:minmax_by) unless block_given?
    min_object, min_result = nil, MOST_EXTREME_OBJECT_EVER
    max_object, max_result = nil, MOST_EXTREME_OBJECT_EVER
    each do |object|
      result = yield object
      min_object, min_result = object, result if min_result > result
      max_object, max_result = object, result if max_result < result
    end
    [min_object, max_object]
  end unless method_defined? :minmax_by

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def none?(&block)
    !any?(&block)
  end unless method_defined? :none?

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def one?(&block)
    return one?{|o| o} unless block_given?
    1 == count(&block)
  end unless method_defined? :one?

  alias_method :reduce, :inject unless method_defined? :reduce
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def reverse_each(&block)
    return to_enum(:reverse_each) unless block_given?
    # There is no other way then to convert to an array first... see 1.9's source.
    to_a.reverse_each(&block)
    self
  end unless method_defined? :reverse_each
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def take(n)
    returning([]) do |array|
      each do |elem|
        array << elem
        break if array.size >= n
      end unless n <= 0
    end
  end unless method_defined? :take
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def take_while
    return to_enum(:take_while) unless block_given?
    inject([]) do |array, elem|
      return array unless yield elem
      array << elem
    end
  end unless method_defined? :take_while

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  if instance_method(:to_a).arity.zero?
    def to_a_with_optional_arguments(*args)
      return to_a_without_optional_arguments if args.empty?
      to_enum(:each, *args).to_a
    end
    alias_method_chain :to_a, :optional_arguments
  end
  
end

require 'enumerator'
module Enumerable
  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def count(item = Backports::Undefined)
    seq = 0
    if item != Backports::Undefined
      each { |o| seq += 1 if item == o }
    elsif block_given?
      each { |o| seq += 1 if yield(o) }
    else
      each { seq += 1 }
    end
    seq
  end unless method_defined? :count
  
  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def cycle(n = nil)
    return to_enum(:cycle, n) unless block_given?
    if n.nil?
      each{|e| yield e } until false
    else
      n = Backports.coerce_to_int(n)
      if n >= 1
        cache = []
        each do |elem|
          cache << elem
          yield elem
        end
        (n-1).times do
          cache.each{|e| yield e }
        end
      end
    end
    nil
  end unless method_defined? :cycle
  
  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  Backports.make_block_optional self, :each_cons, :each_slice, :test_on => 1..2, :arg => 1

  Backports.make_block_optional self, :detect, :find, :find_all, :select, :sort_by, :partition, :reject, :test_on => 1..2
  
  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def drop(n)
    n = Backports.coerce_to_int(n)
    raise ArgumentError, "attempt to drop negative size" if n < 0
    ary = to_a
    return [] if n > ary.size
    ary[n...ary.size]
  end unless method_defined? :drop
  
  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def drop_while
    return to_enum(:drop_while) unless block_given?
    ary = []
    dropping = true
    each do |obj|
      ary << obj unless dropping &&= yield(obj)
    end
    ary
  end unless method_defined? :drop_while
  
  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  if instance_method(:each_with_index).arity.zero?
    def each_with_index_with_optional_args_and_block(*args)
      return to_enum(:each_with_index, *args) unless block_given?
      idx = 0
      each(*args) { |o| yield(o, idx); idx += 1 }
      self
    end
    Backports.alias_method_chain self, :each_with_index, :optional_args_and_block
  end

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def find_index(obj = Backports::Undefined)
    if obj != Backports::Undefined
      each_with_index do |element, i|
        return i if element == obj
      end
    elsif block_given?
      each_with_index do |element, i|
        return i if yield element
      end
    else
      return to_enum(:find_index)
    end
    nil
  end unless method_defined? :find_index
  
  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def first(n = Backports::Undefined)
    return take(n) unless n == Backports::Undefined
    each{|obj| return obj}
    nil
  end unless method_defined? :first

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def group_by
    return to_enum(:group_by) unless block_given?
    {}.tap do |result|
      each do |o|
        result.fetch(yield(o)){|key| result[key] = []} << o
      end
    end
  end unless method_defined? :group_by
  
  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  unless ((1..2).inject(:+) rescue false)
    def inject_with_symbol(*args, &block)
      return inject_without_symbol(*args, &block) if block_given? && args.size <= 1
      method = args.pop
      inject_without_symbol(*args) {|memo, obj| memo.send(method, obj)}
    end
    Backports.alias_method_chain self, :inject, :symbol
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

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def max_by
    return to_enum(:max_by) unless block_given?
    max_object, max_result = nil, MOST_EXTREME_OBJECT_EVER
    each do |object|
      result = yield object
      max_object, max_result = object, result if max_result < result
    end
    max_object
  end unless method_defined? :max_by

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def min_by
    return to_enum(:min_by) unless block_given?
    min_object, min_result = nil, MOST_EXTREME_OBJECT_EVER
    each do |object|
      result = yield object
      min_object, min_result = object, result if min_result > result
    end
    min_object
  end unless method_defined? :min_by

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def minmax
    return minmax{|a,b| a <=> b} unless block_given?
    first_time = true
    min, max = nil
    each do |object|
      if first_time
        min = max = object
        first_time = false
      else
        min = object if Backports.coerce_to_comparison(min, object, yield(min, object)) > 0
        max = object if Backports.coerce_to_comparison(max, object, yield(max, object)) < 0
      end
    end
    [min, max]
  end unless method_defined? :minmax
  
  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def minmax_by
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

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def none?(&block)
    !any?(&block)
  end unless method_defined? :none?

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def one?
    found_one = false
    if block_given?
      each do |o|
        if yield(o)
          return false if found_one
          found_one = true
        end
      end
    else
      each do |o|
        if o
          return false if found_one
          found_one = true
        end
      end
    end
    found_one
  end unless method_defined? :one?

  Backports.alias_method self, :reduce, :inject
  
  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def reverse_each
    return to_enum(:reverse_each) unless block_given?
    # There is no other way then to convert to an array first... see 1.9's source.
    to_a.reverse_each{|e| yield e}
    self
  end unless method_defined? :reverse_each
  
  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def take(n)
    n = Backports.coerce_to_int(n)
    raise ArgumentError, "attempt to take negative size: #{n}" if n < 0
    [].tap do |array|
      each do |elem|
        array << elem
        break if array.size >= n
      end unless n <= 0
    end
  end unless method_defined? :take
  
  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def take_while
    return to_enum(:take_while) unless block_given?
    inject([]) do |array, elem|
      return array unless yield elem
      array << elem
    end
  end unless method_defined? :take_while

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  if instance_method(:to_a).arity.zero?
    def to_a_with_optional_arguments(*args)
      return to_a_without_optional_arguments if args.empty?
      to_enum(:each, *args).to_a
    end
    Backports.alias_method_chain self, :to_a, :optional_arguments
  end
  
  # alias_method gives a warning, so instead copy-paste:
  if instance_method(:entries).arity.zero?
    def entries_with_optional_arguments(*args)
      return entries_without_optional_arguments if args.empty?
      to_enum(:each, *args).entries
    end
    Backports.alias_method_chain self, :entries, :optional_arguments
  end
  
end

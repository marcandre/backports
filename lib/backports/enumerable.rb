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
  def first(*arg)
      arg.empty? ? take(1)[0] : take(arg.first)
  end unless method_defined? :first

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def reverse_each(&block)
    return to_enum(:reverse_each) unless block_given?
    # There is no other way then to convert to an array first... see 1.9's source.
    to_a.reverse_each(&block)
    self
  end unless method_defined? :reverse_each
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  unless ((1..2).each_slice(1) rescue false)
    def each_slice_with_optional_block(len, &block)
      raise ArgumentError, "invalid slice size" if len <= 0
      return to_enum(:each_slice, len) unless block_given?
      each_slice_without_optional_block(len, &block)
    end
    alias_method_chain :each_slice, :optional_block
  end
  
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
  unless ((1..2).each_cons(1) rescue false)
    def each_cons_with_optional_block(len, &block)
      raise ArgumentError, "invalid size" if len <= 0
      return to_enum(:each_cons, len) unless block_given?
      each_cons_without_optional_block(len, &block)
    end
    alias_method_chain :each_cons, :optional_block
  end

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
  def none?(&block)
    !any?(&block)
  end unless method_defined? :none?

end

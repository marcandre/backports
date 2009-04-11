module Enumerable
  # Standard in rails... See official documentation[http://api.rubyonrails.org/classes/Enumerable.html]
  def sum(identity = 0, &block)
    return identity unless size > 0

    if block_given?
      map(&block).sum
    else
      inject { |sum, element| sum + element }
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
    raise NotImplemented unless block_given? #todo: what should this do?
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
    raise NotImplemented unless block_given? #todo: what should this do?
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

end

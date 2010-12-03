class Array
  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Array.html]
  def combination(num)
    num = Backports.coerce_to_int(num)
    return to_enum(:combination, num) unless block_given?
    return self unless (0..size).include? num
    # Implementation note: slightly tricky.
                                             # Example: self = 1..7, num = 3
    picks = (0...num).to_a                   # picks start at 0, 1, 2
    max_index = ((size-num)...size).to_a           # max (index for a given pick) is [4, 5, 6]
    pick_max_pairs = picks.zip(max_index).reverse  # pick_max_pairs = [[2, 6], [1, 5], [0, 4]]
    lookup = pick_max_pairs.find(Proc.new{return self})
    loop do
      yield values_at(*picks)
      move = lookup.each{|pick, max| picks[pick] < max}.first
      new_index = picks[move] + 1
      picks[move...num] = (new_index...(new_index+num-move)).to_a
    end
  end unless method_defined? :combination

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Array.html]
  def cycle(n = nil)
    return to_enum(:cycle, n) unless block_given?
    if n.nil?
      each{|e| yield e } until false
    else
      n = Backports.coerce_to_int(n)
      n.times{each{|e| yield e }}
    end
    nil
  end unless method_defined? :cycle

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Array.html]
  Backports.make_block_optional self, :collect!, :map!, :each, :each_index, :reverse_each, :reject, :reject!, :delete_if, :select, :test_on => [42]

  # flatten & flatten!, standard in ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Array.html]
  unless ([[]].flatten(1) rescue false)

    # Recursively flatten any contained Arrays into an one-dimensional result.
    # Adapted from rubinius'
    def flatten_with_optional_argument(level=-1)
      dup.flatten!(level) || self
    end

    # Flattens self in place as #flatten. If no changes are
    # made, returns nil, otherwise self.
    # Adapted from rubinius'
    def flatten_with_optional_argument!(level=-1)
      level = Backports.coerce_to_int(level)
      return flatten_without_optional_argument! unless level >= 0

      ret, out = nil, []
      ret = recursively_flatten_finite(self, out, level)
      replace(out) if ret
      ret
    end

    Backports.alias_method_chain self, :flatten, :optional_argument
    Backports.alias_method_chain self, :flatten!, :optional_argument

    # Helper to recurse through flattening
    # Adapted from rubinius'; recursion guards are not needed because level is finite
    def recursively_flatten_finite(array, out, level)
      ret = nil
      if level <= 0
        out.concat(array)
      else
        array.each do |o|
          if o.respond_to? :to_ary
            recursively_flatten_finite(o.to_ary, out, level - 1)
            ret = self
          else
            out << o
          end
        end
      end
      ret
    end
    private :recursively_flatten_finite
  end # flatten & flatten!

  # index. Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Array.html]
  unless ([1].index{true} rescue false)
    def index_with_block(*arg)
      return index_without_block(*arg) unless block_given? && arg.empty?
      each_with_index{|o,i| return i if yield o}
      return nil
    end
    Backports.alias_method_chain self, :index, :block
    alias_method :find_index, :index
  end

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Array.html]
  def permutation(num = Backports::Undefined)
    return to_enum(:permutation, num) unless block_given?
    num = num.equal?(Backports::Undefined) ?
          size :
          Backports.coerce_to_int(num)
    return self unless (0..size).include? num

    final_lambda = lambda do |partial, remain|
      yield partial
    end

    outer_lambda = num.times.inject(final_lambda) do |proc, ignore|
      lambda do |partial, remain|
        remain.each_with_index do |val, i|
          new_remain = remain.dup
          new_remain.delete_at(i)
          proc.call(partial.dup << val, new_remain)
        end
      end
    end

    outer_lambda.call([], self)
  end unless method_defined? :permutation

  # pop. Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Array.html]
  unless ([1].pop(1) rescue false)
    def pop_with_optional_argument(n = Backports::Undefined)
      return pop_without_optional_argument if n == Backports::Undefined
      n = Backports.coerce_to_int(n)
      raise ArgumentError, "negative array size" if n < 0
      first = size - n
      first = 0 if first < 0
      slice!(first..size).to_a
    end
    Backports.alias_method_chain self, :pop, :optional_argument
  end

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Array.html]
  def product(*arg)
    # Implementation notes: We build a block that will generate all the combinations
    # by building it up successively using "inject" and starting with one
    # responsible to append the values.
    #
    result = []

    arg.map!{|ary| Backports.coerce_to_ary(ary)}
    arg.reverse! # to get the results in the same order as in MRI, vary the last argument first
    arg.push self

    outer_lambda = arg.inject(result.method(:push)) do |proc, values|
      lambda do |partial|
        values.each do |val|
          proc.call(partial.dup << val)
        end
      end
    end

    outer_lambda.call([])

    result
  end unless method_defined? :product

  # rindex. Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Array.html]
  unless ([1].rindex{true} rescue false)
    def rindex_with_block(*arg)
      return rindex_without_block(*arg) unless block_given? && arg.empty?
      reverse_each.each_with_index{|o,i| return size - 1 - i if yield o}
      return nil
    end
    Backports.alias_method_chain self, :rindex, :block
  end

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Array.html]
  # Note: was named #choice in 1.8.7 and renamed in later versions
  def sample(n = Backports::Undefined)
    return self[Kernel.rand(size)] if n == Backports::Undefined
    n = Backports.coerce_to_int(n)
    raise ArgumentError, "negative array size" if n < 0
    n = size if n > size
    result = Array.new(self)
    n.times do |i|
      r = i + Kernel.rand(size - i)
      result[i], result[r] = result[r], result[i]
    end
    result[n..size] = []
    result
  end unless method_defined? :sample
  
  # shift. Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Array.html]
  unless ([1].shift(1) rescue false)
    def shift_with_optional_argument(n = Backports::Undefined)
      return shift_without_optional_argument if n == Backports::Undefined
      n = Backports.coerce_to_int(n)
      raise ArgumentError, "negative array size" if n < 0
      slice!(0, n)
    end
    Backports.alias_method_chain self, :shift, :optional_argument
  end

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Array.html]
  def shuffle
    dup.shuffle!
  end unless method_defined? :shuffle

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Array.html]
  def shuffle!
    raise TypeError, "can't modify frozen array" if frozen?
    size.times do |i|
      r = i + Kernel.rand(size - i)
      self[i], self[r] = self[r], self[i]
    end
    self
  end unless method_defined? :shuffle!

end
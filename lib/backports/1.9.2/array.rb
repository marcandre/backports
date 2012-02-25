class Array
  # Standard in Ruby 1.9.2 See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def keep_if
    return to_enum(:keep_if) unless block_given?
    delete_if{|elem| !yield elem}
  end unless method_defined? :keep_if

  if [1].product([2]){break false}
    def product_with_block(*arg, &block)
      return product_without_block(*arg) unless block_given?
      # Same implementation as 1.8.7, but yielding
      arg.map!{|ary| Backports.coerce_to_ary(ary)}
      arg.reverse! # to get the results in the same order as in MRI, vary the last argument first
      arg.push self

      outer_lambda = arg.inject(block) do |proc, values|
        lambda do |partial|
          values.each do |val|
            proc.call(partial.dup << val)
          end
        end
      end

      outer_lambda.call([])
      self
    end
    Backports.alias_method_chain self, :product, :block
  end

  # Note: Combinations are not yielded in the same order as MRI.
  # This is not a bug; the spec states that the order is implementation dependent
  def repeated_combination(num)
    return to_enum(:repeated_combination, num) unless block_given?
    num = Backports.coerce_to_int(num)
    if num <= 0
      yield [] if num == 0
    else
      indices = Array.new(num, 0)
      indices[-1] = size
      while dec = indices.find_index(&:nonzero?)
        indices[0..dec] = Array.new dec+1, indices[dec]-1
        yield values_at(*indices)
      end
    end
    self
  end unless method_defined? :repeated_combination

  # Note: Permutations are not yielded in the same order as MRI.
  # This is not a bug; the spec states that the order is implementation dependent
  def repeated_permutation(num)
    return to_enum(:repeated_permutation, num) unless block_given?
    num = Backports.coerce_to_int(num)
    if num <= 0
      yield [] if num == 0
    else
      indices = Array.new(num, 0)
      indices[-1] = size
      while dec = indices.find_index(&:nonzero?)
        indices[0...dec] = Array.new dec, size-1
        indices[dec] -= 1
        yield values_at(*indices)
      end
    end
    self
  end unless method_defined? :repeated_permutation

  def rotate(n=1)
    Array.new(self).rotate!(n)
  end unless method_defined? :rotate

  def rotate!(n=1)
    n = Backports.coerce_to_int(n) % (empty? ? 1 : size)
    concat(shift(n))
  end unless method_defined? :rotate!

  def select!
    return to_enum(:select!) unless block_given?
    reject!{|elem| ! yield elem}
  end unless method_defined? :select!

  def sort_by!
    return to_enum(:sort_by!) unless block_given?
    raise "can't modify frozen array" if frozen?
    replace sort_by{|e| yield e}
  end unless method_defined? :sort_by!

  unless [1,2].uniq!{}
    def uniq_with_block!
      return uniq_without_block! unless block_given?
      replace self if frozen? # force error
      u = uniq{|e| yield e}
      replace u unless u.size == size
    end
    Backports.alias_method_chain self, :uniq!, :block
  end

  unless [1,2].uniq{}.size == 1
    def uniq_with_block
      return uniq_without_block unless block_given?
      h = {}
      each do |elem|
        h[yield(elem)] ||= elem
      end
      h.values
    end
    Backports.alias_method_chain self, :uniq, :block
  end

end
    
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

  def rotate(n=1)
    dup.rotate!(n)
  end unless method_defined? :rotate

  def rotate!(n=1)
    return self if empty?
    n %= size
    concat(slice!(0, n))
  end unless method_defined? :rotate!

  def select!(&block)
    return to_enum(:select!) unless block_given?
    reject!{|elem| ! yield elem}
  end unless method_defined? :select!

  def sort_by!(&block)
    return to_enum(:sort_by!) unless block_given?
    replace sort_by(&block)
  end unless method_defined? :sort_by!

  unless [1,2].uniq!{}
    def uniq_with_block!(&block)
      return uniq_without_block! unless block_given?
      u = uniq(&block)
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
    
class Array
  # Standard in Ruby 1.9.2 See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def keep_if
    return to_enum(:keep_if) unless block_given?
    delete_if{|elem| !yield elem}
  end unless method_defined? :keep_if

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
        h[yield elem] ||= elem
      end
      h.values
    end
    Backports.alias_method_chain self, :uniq, :block
  end

end
    
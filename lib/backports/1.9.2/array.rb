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
end
    
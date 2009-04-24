class Fixnum
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Fixnum.html]
  def div(n)
    (self / n).round
  end unless method_defined? :div

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Fixnum.html]
  def even?
    self & 1 == 0
  end unless method_defined? :even?

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Fixnum.html]
  def fdiv(n)
    to_f / n
  end unless method_defined? :fdiv

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Fixnum.html]
  def odd?
    self & 1 == 1
  end unless method_defined? :odd?

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Fixnum.html]
  def succ
    self + 1
  end unless method_defined? :succ
  
  alias_method :magnitude, :abs unless method_defined? :magnitude
  
  
  
  
  
end
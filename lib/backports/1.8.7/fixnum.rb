class Fixnum
  # Standard in ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Fixnum.html]
  def div(n)
    (self / n).to_i
  end unless method_defined? :div

  # Standard in ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Fixnum.html]
  def fdiv(n)
    to_f / n
  end unless method_defined? :fdiv
end
class Binding
  # Standard in ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Symbol.html]
  def eval(expr, *arg)
    Kernel.eval(expr, self, *arg)
  end unless method_defined? :eval
end
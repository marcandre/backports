class Fixnum
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Fixnum.html]
  def odd?
    self & 1 == 1
  end unless method_defined? :odd?
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Fixnum.html]
  def even?
    self & 1 == 0
  end unless method_defined? :even?
end
class Integer
  Backports.make_block_optional self, :downto, :upto, :test_on => 42, :arg => 42
  Backports.make_block_optional self, :times, :test_on => 42

  # Standard in ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Fixnum.html]
  def even?
    self[0].zero?
  end unless method_defined? :even?

  # Standard in ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Fixnum.html]
  def odd?
    !even?
  end unless method_defined? :odd?

  # Standard in ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Fixnum.html]
  def ord
    self
  end unless method_defined? :ord

  # Standard in ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Fixnum.html]
  def pred
    self - 1
  end unless method_defined? :pred
end
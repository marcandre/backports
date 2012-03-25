class String
  # Standard in Ruby 1.9.3 See official documentation[http://ruby-doc.org/core-1.9.3/String.html#method-i-prepend]
  def prepend(other_str)
    replace Backports.coerce_to_str(other_str) + self
    self
  end unless method_defined? :prepend
end

class Array
  def intersection(*arrays)
    arrays.inject(Array.new(self), :&)
  end unless method_defined? :intersection
end

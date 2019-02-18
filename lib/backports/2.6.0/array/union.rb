class Array
  def union(*arrays)
    arrays.inject(self, :|)
  end unless method_defined? :union
end

class NilClass
  def dup
    self
  end
end unless (nil.dup rescue false)

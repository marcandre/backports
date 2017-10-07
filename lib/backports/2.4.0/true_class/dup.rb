class TrueClass
  def dup
    self
  end
end unless (true rescue false)


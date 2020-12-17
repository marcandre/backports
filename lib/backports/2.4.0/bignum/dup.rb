class Bignum
  def dup
    self
  end
end unless ((1 << 64).dup rescue false)

class Complex
  def to_r
    raise "Can't convert #{self} into Rational" unless imag.eql?(0)
    real.to_r
  end
end

class Integer
  Backports.alias_method self, :magnitude, :abs

  if instance_method(:round).arity.zero?
    def round_with_digits(ndigits=0)
      ndigits = Backports::coerce_to_int(ndigits)
      case
      when ndigits.zero?
        self
      when ndigits > 0
        Float(self)
      else
        pow = 10 ** (-ndigits)
        remain = self % pow
        comp = self < 0 ? :<= : :<
        remain -= pow unless remain.send(comp, pow / 2)
        self - remain
      end
    end
    Backports.alias_method_chain self, :round, :digits
  end
end
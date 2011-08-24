class Float
  if instance_method(:round).arity.zero?
    def round_with_digits(ndigits=0)
      ndigits = Backports::coerce_to_int(ndigits)
      case
      when ndigits.zero?
        round_without_digits
      when ndigits < 0
        p = 10 ** -ndigits
        p > abs ? 0 : (self / p).round * p
      else
        p = 10 ** ndigits
        prod = self * p
        prod.infinite? ? self : prod.round.fdiv(p)
      end
    end
    Backports.alias_method_chain self, :round, :digits
  end
end
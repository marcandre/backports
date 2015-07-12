unless Bignum.method_defined? :bit_length
  require 'backports/2.0.0/range/bsearch'
  class Bignum
    def bit_length
      # We use the fact that bignums use the minimum number of bytes necessary
      # So we have (size - 1) * 8 < bit_length <= size * 8
      n = 8 * (size - 1)
      smaller = self >> n
      if smaller >= 0
        smaller += 1
      else
        smaller = -smaller
      end
      n + (1..8).bsearch{|i| smaller <= (1 << i) }
    end
  end
end

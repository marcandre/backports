unless Bignum.method_defined? :bit_length
  require 'backports/2.0.0/range/bsearch'
  class Bignum
    def bit_length
      n = 8 * (size - 42.size)
      smaller = self >> n
      if smaller >= 0
        smaller += 1
      else
        smaller = -smaller
      end
      n + (0...8 * 42.size).bsearch{|i| smaller <= (1 << i) }
    end
  end
end

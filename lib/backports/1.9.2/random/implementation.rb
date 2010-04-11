class Random
  # Implementation corresponding to the actual Random class of Ruby
  # The actual random generator (mersenne twister) is in MT19937.
  # Ruby specific conversions are handled in bits_and_bytes.
  # The high level stuff (argument checking) is done here.
  #
  module Implementation
    attr_reader :seed

    def initialize(seed = 0)
      super()
      srand(seed)
    end

    def srand(new_seed = 0)
      new_seed = Backports.coerce_to_int(new_seed)
      old, @seed = @seed, new_seed.nonzero? || Random.new_seed
      @mt = MT19937[ @seed ]
      old
    end

    def rand(limit = Backports::Undefined)
      case limit
        when Backports::Undefined
          @mt.random_float
        when Float
          limit * @mt.random_float unless limit <= 0
        when Range
          _rand_range(limit)
        else
          limit = Backports.coerce_to_int(limit)
          @mt.random_integer(limit) unless limit <= 0
      end || raise(ArgumentError, "invalid argument #{limit}")
    end

    def bytes(nb)
      nb = Backports.coerce_to_int(nb)
      raise ArgumentError, "negative size" if nb < 0
      @mt.random_bytes(nb)
    end

    def ==(other)
      other.is_a?(Random) &&
        seed == other.seed &&
        left == other.send(:left) &&
        state == other.send(:state)
    end

  private
    def state
      @mt.to_bignum
    end

    def left
      MT19937::STATE_SIZE - @mt.last_read
    end

    def _rand_range(limit)
      if limit.end.is_a?(Float)
        from = Backports.coerce_to(limit.begin, Float, :to_f)
        to = limit.end
        range = to - from
        if range < 0
          nil
        elsif limit.exclude_end?
          from + @mt.random_float * range unless range <= 0
        else
          # cheat a bit... this will reduce the nb of random bits
          loop do
            r = @mt.random_float * range * 1.0001
            break from + r unless r > range
          end
        end
      else
        from, to = [limit.begin, limit.end].map(&Backports.method(:coerce_to_int))
        to += 1 unless limit.exclude_end?
        range = to - from
        from + @mt.random_integer(range) unless range <= 0
      end
    end
  end

  def self.new_seed
    Kernel::srand # use the built-in seed generator
    Kernel::srand # return the generated seed
  end
end
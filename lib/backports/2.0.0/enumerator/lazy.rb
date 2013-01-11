class Enumerator
  class Yielder
    # Current API for Lazy Enumerator does not provide an easy way
    # to handle internal state. We "cheat" and use yielder to hold it for us.
    # A new yielder is created when generating or after a `rewind`.
    # This way we avoid issues like http://bugs.ruby-lang.org/issues/7691
    # or http://bugs.ruby-lang.org/issues/7696
    attr_accessor :backports_memo
  end

  class Lazy < Enumerator
    @@done = Object.new   # used internally to bail out of an iteration

    alias_method :non_lazy_cycle, :cycle # cycle must be handled in a tricky way
    @@cycler = Struct.new(:object, :n)

    def initialize(obj)
      return super(obj.object, :non_lazy_cycle, obj.n) if obj.is_a?(@@cycler)
      raise ArgumentError, "must supply a block" unless block_given?
      super() do |yielder, *args|
        catch @@done do
          obj.each(*args) do |*x|
            yield yielder, *x
          end
        end
      end
    end

    alias_method :force, :to_a

    def lazy
      self
    end

    def map
      raise ArgumentError, "tried to call lazy map without a block" unless block_given?
      Lazy.new(self) do |yielder, *values|
        yielder << yield(*values)
      end
    end
    alias_method :collect, :map

    def select
      raise ArgumentError, "tried to call lazy select without a block" unless block_given?
      Lazy.new(self) do |yielder, *values|
        values = values.first unless values.size > 1
        yielder.yield values if yield values
      end
    end
    alias_method :find_all, :select

    def reject
      raise ArgumentError, "tried to call lazy reject without a block" unless block_given?
      Lazy.new(self) do |yielder, *values|
        values = values.first unless values.size > 1
        yielder.yield(values) unless yield values
      end
    end

    def grep(pattern)
      if block_given?
        # Split for performance
        Lazy.new(self) do |yielder, *values|
          values = values.first unless values.size > 1
          yielder.yield(yield(values)) if pattern === values
        end
      else
        Lazy.new(self) do |yielder, *values|
          values = values.first unless values.size > 1
          yielder.yield(values) if pattern === values
        end
      end
    end

    def drop(n)
      n = Backports::coerce_to_int(n)
      Lazy.new(self) do |yielder, *values|
        data = yielder.backports_memo ||= {remain: n}
        if data[:remain] > 0
          data[:remain] -= 1
        else
          yielder.yield(*values)
        end
      end
    end

    def drop_while
      raise ArgumentError, "tried to call lazy drop_while without a block" unless block_given?
      Lazy.new(self) do |yielder, *values|
        data = yielder.backports_memo ||= {dropping: true}
        yielder.yield(*values) unless data[:dropping] &&= yield(*values)
      end
    end

    def take(n)
      n = Backports::coerce_to_int(n)
      raise ArgumentError, 'attempt to take negative size' if n < 0
      return Lazy.new([]){} if n == 0
      Lazy.new(self) do |yielder, *values|
        data = yielder.backports_memo ||= {remain: n}
        yielder.yield(*values)
        throw @@done if (data[:remain] -= 1) == 0
      end
    end

    def take_while
      raise ArgumentError, "tried to call lazy take_while without a block" unless block_given?
      Lazy.new(self) do |yielder, *values|
        throw @@done unless yield(*values)
        yielder.yield(*values)
      end
    end

    def flat_map
      raise ArgumentError, "tried to call lazy flat_map without a block" unless block_given?
      Lazy.new(self) do |yielder, *values|
        result = yield(*values)
        if ary = Backports.is_array?(result) || (result.respond_to?(:each) && result.respond_to?(:force))
          ary.each{|x| yielder << x }
        else
          yielder << result
        end
      end
    end
    alias_method :collect_concat, :flat_map

    def cycle(n = nil)
      return super if block_given?
      Lazy.new(@@cycler.new(self, n))
    end

    def zip(*args)
      return super if block_given?
      arys = args.map{ |arg| Backports.is_array?(arg) }
      if arys.all?
        # Handle trivial case of multiple array arguments separately
        # by avoiding Enumerator#next for efficiency & compatibility
        Lazy.new(self) do |yielder, *values|
          data = yielder.backports_memo ||= {iter: 0}
          values = values.first unless values.size > 1
          yielder << arys.map{|ary| ary[data[:iter]]}.unshift(values)
          data[:iter] += 1
        end
      else
        Lazy.new(self) do |yielder, *values|
          enums = yielder.backports_memo ||= args.map(&:each)
          values = values.first unless values.size > 1
          others = enums.map do |arg|
            begin
              arg.next
            rescue StopIteration
              nil
            end
          end
          yielder << others.unshift(values)
        end
      end
    end
  end
end

unless Enumerator.respond_to?(:produce)
  class Enumerator
    NOVALUE__ = Object.new.freeze

    def self.produce(initial = NOVALUE__)
      raise ArgumentError, 'no block given' unless block_given?

      Enumerator.new do |y|
        val = initial == NOVALUE__ ? yield() : initial

        loop do
          y << val
          val = yield(val)
        end
      end
    end
  end
end
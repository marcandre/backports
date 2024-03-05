unless Enumerator.method_defined? :product
  if RUBY_VERSION >= '2.7'
    instance_eval <<-'EOT', __FILE__, __LINE__ + 1
      def Enumerator.product(*enums, **kwargs, &block)
        if kwargs && !kwargs.empty?
          raise ArgumentError, "unknown keywords: #{kwargs.keys.map(&:inspect).join(', ')}"
        end
        Enumerator::Product.new(*enums).each(&block)
      end
    EOT
  else
    def Enumerator.product(*enums, &block)
      kwargs = enums[-1]
      if kwargs.is_a?(Hash) && !kwargs.empty?
        raise ArgumentError, "unknown keywords: #{kwargs.keys.map(&:inspect).join(', ')}"
      end
      Enumerator::Product.new(*enums).each(&block)
    end
  end

  class Enumerator::Product < Enumerator
    if RUBY_VERSION >= '2.7'
      module_eval <<-EOT, __FILE__, __LINE__ + 1
        def initialize(*enums, **nil)
          @__enums = enums
        end
      EOT
    else
      # rubocop:disable Lint/MissingSuper
      def initialize(*enums)
        @__enums = enums
      end
      # rubocop:enable Lint/MissingSuper
    end

    def each(&block)
      return self unless block
      __execute(block, [], @__enums)
    end

    def __execute(block, values, enums)
      if enums.empty?
        block.yield values
      else
        enum, *enums = enums
        enum.each do |val|
          __execute(block, [*values, val], enums)
        end
      end
      nil
    end
    private :__execute

    def size
      total_size = 1
      @__enums.each do |enum|
        return nil unless enum.respond_to?(:size)
        size = enum.size
        return size if size == nil || size == Float::INFINITY || size == 0
        return nil unless size.is_a?(Integer)
        total_size *= size
      end
      total_size
    end

    def rewind
      @__enums.each do |enum|
        enum.rewind if enum.respond_to?(:rewind)
      end
      self
    end
  end
end

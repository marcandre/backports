unless Symbol.method_defined? :name
  if ((ObjectSpace::WeakMap.new[:test] = :test) rescue false)
    # WeakMaps accept symbols only in Ruby 2.7+
    def Backports.symbol_names
      @symbol_names ||= ObjectSpace::WeakMap.new
    end

    class Symbol
      def name
        Backports.symbol_names[self] ||= to_s.freeze
      end
    end
  else
    # For earlier Rubies, we can't pool their strings
    class Symbol
      def name
        to_s.freeze
      end
    end
  end
end

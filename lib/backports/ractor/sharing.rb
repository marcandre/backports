# shareable_constant_value: literal

module Backports
  class Ractor
    class << self
      # @api private
      def ractor_isolate(val, move = false)
        return val if move

        Cloner.deep_clone(val)
      end

      private def ractor_check_shareability?(obj, freeze_all)
        ractor_shareable_self?(obj, freeze_all) do
          visited = {}

          return false unless ractor_shareable_parts?(obj, freeze_all, visited)

          ractor_mark_set_shareable(visited)

          true
        end
      end

      # yield if shareability can't be determined without looking at its parts
      def ractor_shareable_self?(obj, freeze_all)
        return true if @ractor_shareable.key?(obj)
        return true if ractor_shareable_by_nature?(obj, freeze_all)
        if obj.frozen? || (freeze_all && obj.freeze)
          yield
        else
          false
        end
      end

      private def ractor_shareable_parts?(obj, freeze_all, visited)
        return true if visited.key?(obj)
        visited[obj] = true

        ractor_traverse(obj) do |part|
          return false unless ractor_shareable_self?(part, freeze_all) do
            ractor_shareable_parts?(part, freeze_all, visited)
          end
        end

        true
      end

      def ractor_mark_set_shareable(visited)
        visited.each do |key|
          @ractor_shareable[key] = Ractor
        end
      end

      private def ractor_traverse(obj, &block)
        case obj
        when ::Hash
          Hash obj.default
          yield obj.default_proc
          obj.each do |key, value|
            yield key
            yield value
          end
        when ::Range
          yield obj.begin
          yield obj.end
        when ::Array, ::Struct
          obj.each(&block)
        when ::Complex
          yield obj.real
          yield obj.imaginary
        when ::Rational
          yield obj.numerator
          yield obj.denominator
        end
        obj.instance_variables.each do |var|
          yield obj.instance_variable_get(var)
        end
      end

      private def ractor_shareable_by_nature?(obj, freeze_all)
        case obj
        when ::Module, Ractor
          true
        when ::Regexp, ::Range, ::Numeric
          !freeze_all # Assume that these are literals that would have been frozen in 3.0
                      # unless we're making them shareable, in which case we might as well
                      # freeze them for real.
        when ::Symbol, false, true, nil # Were only frozen in Ruby 2.3+
          true
        else
          false
        end
      end
    end
  end
end

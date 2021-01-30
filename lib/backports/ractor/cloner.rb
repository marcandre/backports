# shareable_constant_value: literal

using ::RubyNext if defined?(::RubyNext)

module Backports
  class Ractor
    class Cloner
      class << self
        def deep_clone(obj)
          return obj if Ractor.ractor_shareable_self?(obj, false) { false }

          new.deep_clone(obj)
        end

        private :new
      end

      def initialize
        @processed = {}.compare_by_identity
        @changed = nil
      end

      def deep_clone(obj)
        result = process(obj) do |r|
          copy_contents(r)
        end
        return result if result

        Ractor.ractor_mark_set_shareable(@processed)
        obj
      end

      # Yields a deep copy.
      # If no deep copy is needed, `obj` is returned and
      # nothing is yielded
      private def clone_deeper(obj)
        return obj if Ractor.ractor_shareable_self?(obj, false) { false }

        result = process(obj) do |r|
          copy_contents(r)
        end
        return obj unless result

        yield result if block_given?
        result
      end

      # Yields if `obj` is a new structure
      # Returns the deep copy, or `false` if no deep copy is needed
      private def process(obj)
        @processed.fetch(obj) do
          # For recursive structures, assume that we'll need a duplicate.
          # If that's not the case, we will have duplicated the whole structure
          # for nothing...
          @processed[obj] = result = obj.dup
          changed = track_change { yield result }
          return false if obj.frozen? && !changed

          @changed = true
          result.freeze if obj.frozen?

          result
        end
      end

      # returns if the block called `deep clone` and that the deep copy was needed
      private def track_change
        prev = @changed
        @changed = false
        yield
        @changed
      ensure
        @changed = prev
      end

      # modifies in place `obj` by calling `deep clone` on its contents
      private def copy_contents(obj)
        case obj
        when ::Hash
          if obj.default
            clone_deeper(obj.default) do |copy|
              obj.default = copy
            end
          end
          obj.transform_keys! { |key| clone_deeper(key) }
          obj.transform_values! { |value| clone_deeper(value) }
        when ::Array
          obj.map! { |item| clone_deeper(item) }
        when ::Struct
          obj.each_pair do |key, item|
            clone_deeper(item) { |copy| obj[key] = copy }
          end
        end
        obj.instance_variables.each do |var|
          clone_deeper(obj.instance_variable_get(var)) do |copy|
            obj.instance_variable_set(var, copy)
          end
        end
      end
    end
    private_constant :Cloner
  end
end

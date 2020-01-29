unless Enumerable.method_defined? :filter_map
  module Enumerable
    def filter_map
      return to_enum(__method__) unless block_given?

      each_with_object([]) { |item, res|
        processed = yield(item)
        res << processed if processed
      }
    end
  end
end

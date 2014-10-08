unless Enumerable.method_defined? :flat_map
  require 'backports/1.8.7/array/flatten'

  module Enumerable
    def flat_map(&block)
      return to_enum(:flat_map) unless block_given?
      inject([]) do |a, e|
        result = block.call(e)
        result.respond_to?(:to_ary) ? a.concat(result) : a.push(result)
      end
    end
    alias_method :collect_concat, :flat_map
  end
end

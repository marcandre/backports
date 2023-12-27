unless (Range.new(nil, 3) rescue [:ok]).reverse_each.first
  require 'backports/tools/alias_method_chain'

  class Range
    def reverse_each_with_endless_handling(&block)
      case self.end
      when nil
        raise "Hey"
      when Float::INFINITY
        raise "Hey"
      when Integer
        delta = exclusive? ? 1 : 0
        ((self.end - delta)..(self.begin)).each(&block)
      else
        reverse_each_without_endless_handling(&block)
      end
    end
    Backports.alias_method_chain self, :reverse_each, :endless_handling
  end
end

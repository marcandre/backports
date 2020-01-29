unless Enumerable.method_defined? :tally
  module Enumerable
    def tally
      # NB: By spec, we can't use Hash.new(0), because tally should return default-less hash
      each_with_object({}) { |item, res|
        res[item] ||= 0
        res[item] += 1
      }
    end
  end
end
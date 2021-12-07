unless Enumerable.method_defined? :tally
  module Enumerable
    def tally
      h = {}
      # NB: By spec, tally should return default-less hash
      each_entry { |item| h[item] = h.fetch(item, 0) + 1 }

      h
    end
  end
end

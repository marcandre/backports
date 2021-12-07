unless ([].tally({}) rescue false)
  require 'backports/tools/arguments'
  require 'backports/2.7.0/enumerable/tally'
  require 'backports/tools/alias_method_chain'

  module Enumerable
    def tally_with_hash_argument(h = ::Backports::Undefined)
      return tally_without_hash_argument if h.equal? ::Backports::Undefined

      h = ::Backports.coerce_to_hash(h)

      each_entry { |item| h[item] = h.fetch(item, 0) + 1 }

      h
    end
    ::Backports.alias_method_chain self, :tally, :hash_argument
  end
end

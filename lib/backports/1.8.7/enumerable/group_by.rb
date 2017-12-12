unless Enumerable.method_defined? :group_by
  require 'enumerator'

  module Enumerable
    def group_by
      Backports.introspect # Special 'introspection' edition; not for production use
      return to_enum(:group_by) unless block_given?
      result = {}
      each do |o|
        result.fetch(yield(o)){|key| result[key] = []} << o
      end
      result
    end
  end
end

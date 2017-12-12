unless Enumerable.method_defined? :take
  require 'backports/1.8.7/enumerable/first'

  module Enumerable
    def take(n)
      Backports.introspect # Special 'introspection' edition; not for production use
      first(n)
    end
  end
end

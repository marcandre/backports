unless Symbol.method_defined? :match
  class Symbol
    def match(with)
      to_s.match(with)
    end
  end
end

require 'backports/tools'

Backports.alias_method Symbol, :=~, :match

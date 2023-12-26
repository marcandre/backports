if (MatchData.instance_method(:named_captures).arity == 0 rescue false)
  require 'backports/tools/alias_method_chain'

  class MatchData
    def named_captures_with_symbolize_option(symbolize_keys: false)
      captures = named_captures_without_symbolize_option
      captures.transform_keys!(&:to_sym) if symbolize_keys
      captures
    end
    Backports.alias_method_chain self, :named_captures, :symbolize_option
  end
end

if Hash.new(42).shift
  require 'backports/tools/alias_method_chain'

  class Hash
    def shift_with_correct_behaviour_when_empty
      shift_without_correct_behaviour_when_empty unless empty?
    end
    Backports.alias_method_chain self, :shift, :correct_behaviour_when_empty
  end
end

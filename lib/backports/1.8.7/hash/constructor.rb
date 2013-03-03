unless (Hash[[[:test, :test]]] rescue false)
  class << Hash
    alias_method :constructor_without_key_value_pair_form, :[]
    def [](*args)
      return constructor_without_key_value_pair_form(*args) unless args.length == 1 && args.first.is_a?(Array)
      h = {}
      args.first.each do |arr|
        next unless arr == Backports.is_array?(arr)
        next unless (1..2).include? arr.size
        h[arr.at(0)] = arr.at(1)
      end
      h
    end
  end
end

unless Symbol.method_defined? :name
  def Backports.symbol_names
    @symbol_names ||= ObjectSpace::WeakMap.new
  end

  class Symbol
    def name
      Backports.symbol_names[self] ||= to_s.freeze
    end
  end
end

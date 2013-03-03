unless Hash.method_defined? :select!
  class Hash
    def select!
      return to_enum(:select!) unless block_given?
      reject!{|key, value| ! yield key, value}
    end
  end
end

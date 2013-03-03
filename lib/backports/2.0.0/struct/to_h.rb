unless Struct.method_defined? :to_h
  class Struct
    def to_h
      Hash[
        self.class.members.each{|m| [m.to_sym, self[m]]}
      ]
    end
  end
end

class Struct
	def to_h
    Hash[
      self.class.members.each{|m| [m.to_sym, self[m]]}
    ]
  end unless method_defined? :to_h
end

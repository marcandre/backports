unless Struct.method_defined? :to_h
  class Struct
    def to_h
      Backports.introspect # Special 'introspection' edition; not for production use
      h = {}
      self.class.members.each{|m| h[m.to_sym] = self[m]}
      h
    end
  end
end

unless Hash.method_defined? :to_proc
  class Hash
    def to_proc
      Backports.introspect # Special 'introspection' edition; not for production use
      h = self
      Proc.new{|*args| h[*args]}
    end
  end
end

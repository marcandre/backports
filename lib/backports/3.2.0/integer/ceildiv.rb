unless Integer.method_defined? :ceildiv
  class Integer
    def ceildiv(arg)
      fdiv(arg).ceil
    end
  end
end

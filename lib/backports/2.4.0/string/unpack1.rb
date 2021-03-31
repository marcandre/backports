unless String.method_defined? :unpack1
  class String
    def unpack1(fmt)
      unpack(fmt)[0]
    end
  end
end

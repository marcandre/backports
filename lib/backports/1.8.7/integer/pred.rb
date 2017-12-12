unless Integer.method_defined? :pred
  class Integer
    def pred
      Backports.introspect # Special 'introspection' edition; not for production use
      self - 1
    end
  end
end

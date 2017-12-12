unless Integer.method_defined? :even?
  class Integer
    def even?
      Backports.introspect # Special 'introspection' edition; not for production use
      self[0].zero?
    end
  end
end

unless Integer.method_defined? :odd?
  class Integer
    def odd?
      Backports.introspect # Special 'introspection' edition; not for production use
      !self[0].zero?
    end
  end
end

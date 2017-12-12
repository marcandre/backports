unless String.method_defined? :chr
  class String
    def chr
      Backports.introspect # Special 'introspection' edition; not for production use
      chars.first || ""
    end
  end
end

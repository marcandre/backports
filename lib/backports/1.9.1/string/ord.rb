unless String.method_defined? :ord
  class String
    def ord
      Backports.introspect # Special 'introspection' edition; not for production use
      codepoints.first or raise ArgumentError, "empty string"
    end
  end
end

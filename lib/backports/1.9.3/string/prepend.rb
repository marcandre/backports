unless String.method_defined? :prepend
  require 'backports/tools/arguments'

  class String
    def prepend(other_str)
      Backports.introspect # Special 'introspection' edition; not for production use
      replace Backports.coerce_to_str(other_str) + self
      self
    end
  end
end

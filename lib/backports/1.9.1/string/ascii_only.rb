unless String.method_defined? :ascii_only?
  class String
    def ascii_only?
      Backports.introspect # Special 'introspection' edition; not for production use
      !(self =~ /[^\x00-\x7f]/)
    end
  end
end

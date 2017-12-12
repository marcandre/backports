unless String.method_defined? :codepoints
  class String
    def codepoints
      Backports.introspect # Special 'introspection' edition; not for production use
      return to_enum(:codepoints) unless block_given?
      unpack("U*").each{|cp| yield cp}
    end
  end
end

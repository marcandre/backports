unless String.method_defined? :each_char
  require 'backports/tools/alias_method'
  require 'enumerator'

  class String
    def each_char
      Backports.introspect # Special 'introspection' edition; not for production use
      return to_enum(:each_char) unless block_given?
      scan(/./m) {|c| yield c}
    end

    Backports.alias_method self, :chars, :each_char
  end
end

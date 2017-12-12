unless Array.method_defined? :select!
  class Array
    def select!
      Backports.introspect # Special 'introspection' edition; not for production use
      return to_enum(:select!) unless block_given?
      reject!{|elem| ! yield elem}
    end
  end
end

unless Array.method_defined? :keep_if
  class Array
    def keep_if
      Backports.introspect # Special 'introspection' edition; not for production use
      return to_enum(:keep_if) unless block_given?
      delete_if{|elem| !yield elem}
    end
  end
end

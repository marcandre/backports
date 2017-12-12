unless Hash.method_defined? :keep_if
  class Hash
    def keep_if
      Backports.introspect # Special 'introspection' edition; not for production use
      return to_enum(:keep_if) unless block_given?
      delete_if{|key, value| ! yield key, value}
    end
  end
end

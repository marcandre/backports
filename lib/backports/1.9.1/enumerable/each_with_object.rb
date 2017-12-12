unless Enumerable.method_defined? :each_with_object
  module Enumerable
    def each_with_object(memo)
      Backports.introspect # Special 'introspection' edition; not for production use
      return to_enum(:each_with_object, memo) unless block_given?
      each {|obj| yield obj, memo}
      memo
    end
  end
end

if Enumerable.instance_method(:entries).arity.zero?
  require 'backports/tools/alias_method_chain'

  module Enumerable
    def entries_with_optional_arguments(*args)
      Backports.introspect # Special 'introspection' edition; not for production use
      return entries_without_optional_arguments if args.empty?
      to_enum(:each, *args).entries
    end
    Backports.alias_method_chain self, :entries, :optional_arguments
  end
end

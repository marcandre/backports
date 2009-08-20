require 'stringio'

module Packable
  module Extensions #:nodoc:
    module String #:nodoc:

      def self.included(base)
        base.class_eval do
          include Packable
          extend ClassMethods
          alias_method_chain :unpack, :long_form
          packers.set :merge_all, :fill => " "
        end
      end

      def write_packed(io, options)
        return io.write_without_packing(self) unless options[:bytes]
        io.write_without_packing(self[0...options[:bytes]].ljust(options[:bytes], options[:fill] || "\000"))
      end

      def unpack_with_long_form(*arg)
        return unpack_without_long_form(*arg) if arg.first.is_a? String
        StringIO.new(self).packed.read(*arg)
      rescue EOFError
        nil
      end

      module ClassMethods #:nodoc:
        def unpack_string(s, options)
          s
        end
      end

    end
  end
end

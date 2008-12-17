require 'stringio'

module Packable
  module Extensions #:nodoc:
    module Array #:nodoc:
      def self.included(base)
        base.class_eval do
          alias_method_chain :pack, :long_form
          include Packable
          extend ClassMethods
        end
      end

      def pack_with_long_form(*arg)
        return pack_without_long_form(*arg) if arg.first.is_a? String
        pio = StringIO.new.packed
        write_packed(pio, *arg)
        pio.string
      end

      def write_packed(io, *how)
        return io << self.original_pack(*how) if how.first.is_a? String
        how = [:repeat => :all] if how.empty?
        current = -1
        how.each do |options|
          repeat = options.is_a?(Hash) ? options.delete(:repeat) || 1 : 1
          repeat = length - 1 - current if repeat == :all
          repeat.times do
            io.write(self[current+=1],options)
          end
        end
      end

      module ClassMethods #:nodoc:
        def read_packed(io, *how)
          raise "Can't support builtin format for arrays" if (how.length == 1) && (how.first.is_a? String)
          how.inject [] do |r, options|
            repeat = options.is_a? Hash ? options.delete(:repeat) || 1 : 1
            (0...repeat).inject r do
              r << io.read(options)
            end
          end
        end
      end
    end
  end
end

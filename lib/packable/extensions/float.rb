module Packable
  module Extensions #:nodoc:
    module Float #:nodoc:
      def self.included(base)
        base.class_eval do
          include Packable
          extend ClassMethods
          packers do |p|
            p.set :merge_all, :precision => :single, :endian => :big
            p.set :double   , :precision => :double
            p.set :float    , {}
            p.set :default  , :float
          end
        end
      end

      def write_packed(io, options)
        io << pack(self.class.pack_option_to_format(options))
      end

      module ClassMethods #:nodoc:
        ENDIAN_TO_FORMAT = Hash.new{|h, endian| raise ArgumentError, "Endian #{endian} is not valid. It must be one of #{h.keys.join(', ')}."}.
          merge!(:big => "G", :network => "G", :little => "E", :native => "D").freeze

        FORMAT_TO_SINGLE_PRECISION = {'G' => 'g', 'E' => 'e', 'D' => 'f'}.freeze

        PRECISION = Hash.new{|h, precision| raise ArgumentError, "Precision #{precision} is not valid. It must be one of #{h.keys.join(', ')}."}.
          merge!(:single => 4, :double => 8).freeze

        def pack_option_to_format(options)
          format = ENDIAN_TO_FORMAT[options[:endian]]
          format = FORMAT_TO_SINGLE_PRECISION[format] if options[:precision] == :single
          format
        end

        def read_packed(io, options)
          s = io.read_exactly(PRECISION[options[:precision]])
          s && s.unpack(pack_option_to_format(options)).first
        end
      end

    end
  end
end

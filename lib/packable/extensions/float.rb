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
        def pack_option_to_format(options)
          format = {:big => "G", :network => "G", :little => "E"}[options[:endian]]
          format.downcase! if options[:precision] == :single
          format
        end

        def read_packed(io, options)
          io.read({:single => 4, :double => 8}[options[:precision]])   \
            .unpack(pack_option_to_format(options))   \
            .first
        end
      end
      
    end
  end
end

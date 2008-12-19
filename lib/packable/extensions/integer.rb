module Packable
  module Extensions #:nodoc:
    module Integer #:nodoc:
      def self.included(base)
        base.class_eval do
          include Packable
          extend ClassMethods
          packers do |p|
            p.set :merge_all      , :bytes=>4, :signed=>true, :endian=>:big
            p.set :default        , :long
            p.set :long           , {}
            p.set :short          , :bytes=>2
            p.set :char           , :bytes=>1, :signed=>false
            p.set :byte           , :bytes=>1
            p.set :unsigned_long  , :bytes=>4, :signed=>false
            p.set :unsigned_short , :bytes=>2, :signed=>false
          end
        end
      end

      def write_packed(io, options)
        val = self
        chars = (0...options[:bytes]).collect do
          byte = val & 0xFF
          val >>= 8
          byte.chr
        end
        chars.reverse! if options[:endian] == :big
        io << chars.join
      end

      module ClassMethods #:nodoc:
        def unpack_string(s,options)
          s = s.reverse if options[:endian != :big]
          r = 0
          s.each_byte {|b| r = (r << 8) + b}
          r -= 1 << (8 * options[:bytes])  if options[:signed] && (1 == r >> (8 * options[:bytes] - 1))
          r
        end
      end

    end
  end
end

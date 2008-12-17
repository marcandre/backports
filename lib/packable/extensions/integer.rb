module Packable
  module Extensions #:nodoc:
    module Integer #:nodoc:
      def self.included(base)
        base.class_eval do
          include Packable
          extend ClassMethods
          packers do |c|
            c.set :merge_all      , :bytes=>4, :signed=>true, :endian=>:big
            c.set :default        , :long
            c.set :long           , {}
            c.set :short          , :bytes=>2
            c.set :char           , :bytes=>1, :signed=>false
            c.set :byte           , :bytes=>1
            c.set :unsigned_long  , :bytes=>4, :signed=>false
            c.set :unsigned_short , :bytes=>2, :signed=>false
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

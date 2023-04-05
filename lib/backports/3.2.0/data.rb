original_verbosity = $VERBOSE
$VERBOSE = nil
if defined?(::Data) && !::Data.respond_to?(:define)
  Object.send(:remove_const, :Data)
end
class ::Data
end

module Backports
  Data = ::Data
end
$VERBOSE = original_verbosity

unless ::Backports::Data.respond_to?(:define)
  require "backports/2.7.0/symbol/end_with"
  require "backports/2.5.0/module/define_method"

  class ::Backports::Data
    def deconstruct
      @__members__.values
    end

    def deconstruct_keys(keys_or_nil)
      return @__members__ unless keys_or_nil

      raise TypeError, "Expected symbols" unless keys_or_nil.is_a?(Array) && keys_or_nil.all? {|s| s.is_a?(Symbol)}
      @__members__.slice(*keys_or_nil)
    end

    def self.define(*members, &block)
      members.each do |m|
        raise TypeError, "#{m} is not a Symbol" unless m.is_a?(Symbol) || m.is_a?(String)
        raise ArgumentError, "invalid data member: #{m}" if m.end_with?("=")
      end
      members = members.map(&:to_sym)
      raise ArgumentError, "duplicate members" if members.uniq!

      klass = instance_eval <<-"end_define", __FILE__, __LINE__ + 1
        Class.new(::Backports::Data) do     # Class.new(::Data) do
          def self.members       #   def self.members
            #{members.inspect}   #     [:a_member, :another_member]
          end                    #   end
        end                      # end
      end_define

      members.each do |m|
        klass.define_method(m) { @__members__[m]}
      end

      class << klass
        def new(*values, **named_values)
          if named_values.empty?
            if values.size > members.size
              raise ArgumentError, "wrong number of arguments (given #{values.size}, expected 0..#{members.size})"
            end
            super(**members.first(values.size).zip(values).to_h)
          else
            unless values.empty?
              raise ArgumentError, "wrong number of arguments (given #{values.size}, expected 0)"
            end
            super(**named_values)
          end
        end
        undef :define
      end

      klass.class_eval(&block) if block

      klass
    end

    def eql?(other)
      return false unless other.instance_of?(self.class)

      @__members__.eql?(other.to_h)
    end

    def ==(other)
      return false unless other.instance_of?(self.class)

      @__members__ == other.to_h
    end

    def hash
      @__members__.hash
    end

    def initialize(**named_values)
      given = named_values.keys
      missing = members - given
      unless missing.empty?
        missing = missing.map(&:inspect).join(", ")
        raise ArgumentError, "missing keywords: #{missing}"
      end
      if members.size < given.size
        extra = (given - members).map(&:inspect).join(", ")
        raise ArgumentError, "unknown keywords: #{extra}"
      end
      @__members__ = named_values.freeze
      freeze
    end

    # Why is `initialize_copy` specialized in MRI and not just `initialize_dup`?
    # Let's follow the pattern anyways
    def initialize_copy(other)
      @__members__ = other.to_h
      freeze
    end

    def inspect
      data = @__members__.map {|k, v| "#{k}=#{v.inspect}"}.join(", ")
      space = data != "" && self.class.name ? " " : ""
      "#<data #{self.class.name}#{space}#{data}>"
    end

    def marshal_dump
      @__members__
    end

    def marshal_load(members)
      @__members__ = members
      freeze
    end

    # class method defined in `define`
    def members
      self.class.members
    end

    class << self
      private :new
    end

    def to_h(&block)
      @__members__.to_h(&block)
    end

    def with(**update)
      return self if update.empty?

      self.class.new(**@__members__.merge(update))
    end
  end
end

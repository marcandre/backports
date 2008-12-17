module Packable
  
  # Packers for any packable class.
  class Packers < Hash
    SPECIAL = [:default, :merge_all].freeze
  
    # Usage:
    #   PackableClass.packers.set :shortcut, :option => value, ...
    #   PackableClass.packers { |c| c.set...; c.set... }
    #   PackableClass.packers.set :shortcut, :another_shortcut
    #   PackableClass.packers.set :shortcut do |packer|
    #     packer.write{|io| io << self.something... }
    #     packer.read{|io| Whatever.new(io.read(...)) }
    #   end
    def set(key, options_or_shortcut={})
      if block_given?
        packer = FilterCapture.new options_or_shortcut
        yield packer
      end
      self[key] = options_or_shortcut
      self
    end

    def initialize(klass) #:nodoc:
      @klass = klass
    end

    def lookup(key) #:nodoc:
      k = @klass
      begin
        if found = Packers.for(k)[key]
          return found
        end
        k = k.superclass
      end while k
      SPECIAL.include?(key) ? {} : raise("Unknown option #{key} for #{@klass}")
    end

    def finalize(options) #:nodoc:
      options = lookup(options) while options.is_a? Symbol
      lookup(:merge_all).merge(options)
    end

    @@packers_for_class = Hash.new{|h, klass| h[klass] = Packers.new(klass)}
    
    # Returns the configuration for the given +klass+.
    def self.for(klass)
      @@packers_for_class[klass]
    end

    def self.to_class_option_list(*arg) #:nodoc:
      r = []
      until arg.empty? do
        k, options = original = arg.shift
        k, options = global_lookup(k) if k.is_a? Symbol
        options ||= arg.first.is_a?(Hash) ? arg.shift.tap{|o| original = [original, o]} : :default
        r << [k, k.packers.finalize(options), original]
      end
      r
    end
    
    def self.to_object_option_list(*arg) #:nodoc:
      r=[]
      until arg.empty? do
        obj = arg.shift
        options = case arg.first
        when Hash, Symbol
          arg.shift
        else
          :default
        end
        r << [obj, obj.class.packers.finalize(options)]
      end
      r
    end

  private
    def self.global_lookup(key) #:nodoc:
      @@packers_for_class.each do |klass, packers|
        if options = packers[key]
          return [klass, options]
        end
      end
      raise "Couldn't find packing option #{key}"
    end

    
  end

  # Use to capture the blocks given to read/write
  class FilterCapture #:nodoc:
    attr_accessor :options
    def initialize(options)
      self.options = options
    end

    def read(&block)
      options[:read_packed] = block
    end

    def write(&block)
      options[:write_packed] = block.unbind
    end
  end
    
end
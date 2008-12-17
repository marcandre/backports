# The Packable mixin itself...

require 'stringio'

module Packable
  def self.included(base) #:nodoc:
    base.class_eval do
      class << self 
        include PackersClassMethod
        include ClassMethods
      end
    end
  end

  # +options+ can be a Hash, a shortcut (Symbol) or a String (old-style)
  def pack(options = :default)
    return [self].pack(options) if options.is_a? String
    (StringIO.new.packed << [self, options]).string
  end

  module PackersClassMethod
    # Returns or yields a the Packers.for(class)
    # Normal use is packers.set ...
    # (see docs or Packers::set for usage)
    def packers
      yield packers if block_given?
      Packers.for(self) 
    end
  end

  module ClassMethods    
    def unpack(s, options = :default)
      return s.unpack(options).first if options.is_a? String
      StringIO.new(s).packed.read(self, options)
    end
 
    # Default +read_packed+ calls either the instance method <tt>read_packed</tt> or the 
    # class method +unpack_string+. Choose:
    # * define a class method +read_packed+ that returns the newly read object
    # * define an instance method +read_packed+ which reads the io into +self+
    # * define a class method +unpack_string+ that reads and returns an object from the string. In this case, options[:bytes] should be specified!
    def read_packed(io, options)
      if method_defined? :read_packed
        mandatory = instance_method(:initialize).arity
        mandatory = -1-mandatory if mandatory < 0
        obj = new(*[nil]*mandatory)
        obj.read_packed(io, options)
        obj
      else
        len = options[:bytes]
        s = len ? io.read(len) : io.read
        unpack_string(s, options)
      end
    end

  end  
end
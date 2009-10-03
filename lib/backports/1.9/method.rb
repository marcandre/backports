# Standard in Ruby 1.9.2. How do you call the backport of a future feature?
unless Kernel.method_defined? :respond_to_missing?
  module MissingMethod
    attr_reader :name

    def call(*arg, &block)
      receiver.send :method_missing, @name, *arg, &block
    end
    alias_method :[], :call

    def eql?(method)
      method.is_a?(MissingMethod) &&
        receiver == method.receiver &&
        name == method.name
    end
    alias_method :==, :eql?

    def arity
      -1
    end

    def owner
      @receiver.class
    end

    def source_location
      nil
    end

    def to_proc
      get_block {|*arg| @receiver.send :method_missing, *arg}
    end

    def unbind
      MissingUnboundMethod.new(owner, name)
    end

    def self.new(receiver, name)
      m = receiver.method :respond_to_missing?
      m.extend self
      m.instance_variable_set :@name, name
      m
    end
    #private
    def get_block(&block)
      block
    end
    private :get_block
  end

  module MissingUnboundMethod
    attr_reader :name
    attr_reader :owner

    def self.new(owner, name)
      um = owner.instance_method :respond_to_missing?
      um.extend self
      um.instance_variable_set :@name, name
      um.instance_variable_set :@owner, owner
      um
    end

    def arity
      -1
    end

    def source_location
      nil
    end

    def bind(to)
      raise TypeError, "bind argument must be an instance of #{@owner}" unless to.is_a? @owner
      MissingMethod.new(to, @name)
    end
  end

  module Kernel
    def respond_to_missing? method
      false
    end

    def respond_to_with_call_to_respond_to_missing? method, include_priv=false
      respond_to_without_call_to_respond_to_missing?(method, include_priv) || respond_to_missing?(method)
    end
    Backports.alias_method_chain self, :respond_to?, :call_to_respond_to_missing

    def method_with_new_repond_to_missing(method)
      method_without_new_repond_to_missing(method)
    rescue NameError
      respond_to_missing?(method) ? MissingMethod.new(self, method): raise
    end
    Backports.alias_method_chain self, :method, :new_repond_to_missing

    def public_method_with_new_repond_to_missing(method)
      public_method_without_new_repond_to_missing(method)
    rescue NameError
      respond_to_missing?(method) ? MissingMethod.new(self, method): raise
    end
    Backports.alias_method_chain self, :public_method, :new_repond_to_missing if method_defined? :public_method
  end
end
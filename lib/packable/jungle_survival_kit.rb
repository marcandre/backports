# Insures that the following basic utilities (standard with ruby 1.9 and/or rails) are defined
# so we can get out of the uncivilized jungle (straight ruby 1.8) alive:
# - +require_relative+
# - +try+
# - +tap+
# - +alias_method_chain+
# - &:some_symbol

# Standard in ruby 1.9. Adapted from Pragmatic's "Programming Ruby" (since their version was buggy...)
module Kernel
  def require_relative(relative_feature) 
    file = caller.first.split(/:\d/,2).first
    if /\A\((.*)\)/ =~ file # eval, etc. 
      raise LoadError, "require_relative is called in #{$1}" 
    end 
    require File.expand_path(relative_feature, File.dirname(file))
  end unless method_defined? :require_relative
end

class Object
  # Standard in rails...
  def try(method_id, *args, &block)
    send(method_id, *args, &block) if respond_to?(method_id, true)
  end unless method_defined? :try

  # Standard in ruby 1.9
  def tap
    yield self
    self
  end unless method_defined? :tap
end

class Module
  # Standard in rails...
  def alias_method_chain(target, feature)
    # Strip out punctuation on predicates or bang methods since
    # e.g. target?_without_feature is not a valid method name.
    aliased_target, punctuation = target.to_s.sub(/([?!=])$/, ''), $1
    yield(aliased_target, punctuation) if block_given?
    
    with_method, without_method = "#{aliased_target}_with_#{feature}#{punctuation}", "#{aliased_target}_without_#{feature}#{punctuation}"
    
    alias_method without_method, target
    alias_method target, with_method
    
    case
      when public_method_defined?(without_method)
        public target
      when protected_method_defined?(without_method)
        protected target
      when private_method_defined?(without_method)
        private target
    end
  end unless method_defined? :alias_method_chain
end

# Standard in ruby 1.9 & rails
unless :to_proc.respond_to?(:to_proc)
  class Symbol
    # Turns the symbol into a simple proc, which is especially useful for enumerations. Examples:
    #
    #   # The same as people.collect { |p| p.name }
    #   people.collect(&:name)
    #
    #   # The same as people.select { |p| p.manager? }.collect { |p| p.salary }
    #   people.select(&:manager?).collect(&:salary)
    def to_proc
      Proc.new { |*args| args.shift.__send__(self, *args) }
    end
  end
end


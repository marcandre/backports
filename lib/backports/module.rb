class Module
  # Standard in rails... See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Module.html]
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
  
  # Can't use alias_method here because of jruby (see http://jira.codehaus.org/browse/JRUBY-2435 )
  def module_exec(*arg, &block)
    instance_exec(*arg, &block)
  end unless method_defined? :module_exec
  alias_method :class_exec, :module_exec unless method_defined? :class_exec
  
end

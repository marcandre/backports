class Module
  # Can't use alias_method here because of jruby (see http://jira.codehaus.org/browse/JRUBY-2435 )
  def module_exec(*arg, &block)
    instance_exec(*arg, &block)
  end unless method_defined? :module_exec
  alias_method :class_exec, :module_exec unless method_defined? :class_exec
end

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
  
  alias_method :module_exec, :instance_exec unless method_defined? :module_exec
  alias_method :class_exec, :module_exec unless method_defined? :class_exec
  
  # Metaprogramming utility to make block optional.
  # Tests first if block is already optional when given options
  def make_block_optional(*methods)
    options = methods.extract_options!
    methods.each do |selector|
      next unless method_defined? selector
      unless options.empty?
        test_on = options[:test_on] || self.new
        next if (test_on.send(selector, *options.fetch(:arg, [])) rescue false)
      end
      alias_method_chain(selector, :optional_block) do |aliased_target, punctuation|
        module_eval <<-end_eval
          def #{aliased_target}_with_optional_block#{punctuation}(*args, &block)
            return to_enum(:#{aliased_target}_without_optional_block#{punctuation}, *args) unless block_given?
            #{aliased_target}_without_optional_block#{punctuation}(*args, &block)
          end
        end_eval
      end
    end
  end
end

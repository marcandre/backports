unless Method.method_defined? :name
  class Method
    attr_accessor :name, :receiver, :owner  
    
    def unbind_with_additional_info
      returning unbind_without_additional_info do |unbound|
        unbound.name = name
        unbound.owner = owner
      end
    end
    alias_method_chain :unbind, :additional_info
  end

  class UnboundMethod
    attr_accessor :name, :owner
    
    def bind_with_additional_info(to)
      returning bind_without_additional_info(to) do |bound|
        bound.name = name
        bound.owner = owner
        bound.receiver = to
      end
    end
    alias_method_chain :bind, :additional_info
  end

  class Object
    def method_with_additional_info(name)
      returning method_without_additional_info(name) do |bound|
        bound.name = name.to_sym
        bound.receiver = self
        bound.owner = self.class.ancestors.find{|mod| mod.instance_methods(false).include? name.to_s}
      end
    end
    alias_method_chain :method, :additional_info
  end

  class Module
    def instance_method_with_additional_info(name)
      returning instance_method_without_additional_info(name) do |unbound|
        unbound.name = name.to_sym
        unbound.owner = ancestors.find{|mod| mod.instance_methods(false).include? name.to_s}
      end
    end
    alias_method_chain :instance_method, :additional_info
  end
end
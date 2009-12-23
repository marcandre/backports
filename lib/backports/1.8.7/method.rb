unless Method.method_defined? :name
  class Method
    attr_accessor :name, :receiver, :owner  
    
    def unbind_with_additional_info
      unbind_without_additional_info.tap do |unbound|
        unbound.name = name
        unbound.owner = owner
      end
    end
    Backports.alias_method_chain self, :unbind, :additional_info
  end

  class UnboundMethod
    attr_accessor :name, :owner
    
    def bind_with_additional_info(to)
      bind_without_additional_info(to).tap do |bound|
        bound.name = name
        bound.owner = owner
        bound.receiver = to
      end
    end
    Backports.alias_method_chain self, :bind, :additional_info
  end

  module Kernel
    def method_with_additional_info(name)
      method_without_additional_info(name).tap do |bound|
        bound.name = name.to_s
        bound.receiver = self
        bound.owner = self.class.ancestors.find{|mod| mod.instance_methods(false).include? bound.name}
      end
    end
    Backports.alias_method_chain self, :method, :additional_info
  end

  class Module
    def instance_method_with_additional_info(name)
      instance_method_without_additional_info(name).tap do |unbound|
        unbound.name = name.to_s
        unbound.owner = ancestors.find{|mod| mod.instance_methods(false).include? unbound.name}
      end
    end
    Backports.alias_method_chain self, :instance_method, :additional_info
  end
end
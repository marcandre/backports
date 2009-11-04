module Kernel
  alias_method :__callee__, :__method__  unless (__callee__ || true rescue false)
  
  def require_relative(relative_feature)
    file = caller.first.split(/:\d/,2).first
    if /\A\((.*)\)/ =~ file # eval, etc. 
      raise LoadError, "require_relative is called in #{$1}" 
    end 
    require File.expand_path(relative_feature, File.dirname(file))
  end unless method_defined? :require_relative

  def public_method(meth)
    if respond_to?(meth) && !protected_methods.include?(meth.to_s)
      method(meth)
    else
      raise NameError, "undefined method `#{meth}' for class `#{self.class}'"
    end
  end unless method_defined? :public_method

  def public_send(method, *args, &block)
    if respond_to?(method) && !protected_methods.include?(method.to_s)
      send(method, *args, &block)
    else
      :foo.generate_a_no_method_error_in_preparation_for_method_missing rescue nil
      # otherwise a NameError might be raised when we call method_missing ourselves
      method_missing(method.to_sym, *args, &block)
    end
  end unless method_defined? :public_send
end
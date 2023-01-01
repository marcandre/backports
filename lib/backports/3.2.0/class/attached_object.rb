unless Class.method_defined? :attached_object
  require 'backports/2.1.0/module/singleton_class'

  class Class
    def attached_object
      raise TypeError, "`#{self}' is not a singleton class" unless singleton_class?
      ObjectSpace.each_object(self).first
    end
  end
end

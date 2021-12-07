unless Class.method_defined? :subclasses
  require 'backports/2.1.0/module/singleton_class'

  class Class
    def subclasses
      ObjectSpace.each_object(singleton_class).reject do |klass|
        klass.superclass != self || klass.singleton_class?
      end
    end
  end
end

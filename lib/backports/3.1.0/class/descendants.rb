unless Class.method_defined? :descendants
  require 'backports/2.1.0/module/singleton_class'

  class Class
    def descendants
      ObjectSpace.each_object(singleton_class).reject do |klass|
        klass.singleton_class? || klass == self
      end
    end
  end
end

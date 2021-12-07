if Module.method_defined? :singleton_class?
  class Module
    def singleton_class?
      # Hacky...
      inspect.start_with? '#<Class:#'
    end
  end
end

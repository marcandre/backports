class Hash
  def to_h
    self
  end unless method_defined? :to_h

  if (({}.default_proc = nil) rescue true)
    def default_proc_with_nil=(proc)
      if proc == nil
        self.default = nil
        self
      else
        self.default_proc_without_nil=(proc)
      end
    end
    Backports.alias_method_chain(self, :default_proc=, :nil)
  end
end

Backports.alias_method(ENV.singleton_class, :to_h, :to_hash)

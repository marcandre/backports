class Hash
  def to_h
    self
  end unless method_defined? :to_h

  def default_proc_with_nil=(proc)
    if proc == nil
      self.default = nil
      self
    else
      self.default_proc_without_nil=(proc)
    end
  end if ({}.default_proc = nil rescue true)
end

Backports.alias_method(ENV, :to_h, :to_hash)

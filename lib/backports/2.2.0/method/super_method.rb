unless Method.method_defined? :super_method
  class Method
    def super_method
      call_chain = receiver.singleton_class.ancestors
      # find current position in call chain:
      skip = call_chain.find_index{|c| c == owner} or return
      call_chain = call_chain.drop(skip + 1)
      # find next in chain with a definition:
      next_index = call_chain.find_index{|c| c.method_defined? name}
      next_index && call_chain[next_index].instance_method(name).bind(receiver)
    end
  end
end

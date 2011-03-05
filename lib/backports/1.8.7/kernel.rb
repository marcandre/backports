module Kernel

  def __method__
    m = caller(1).first[/`(.*)'/,1]
    m.to_sym if m
  end unless (__method__ || true rescue false)

  # Standard in ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Object.html]
  def instance_exec(*arg, &block)
    class << self
      self
    end.send(:define_method, :"temporary method for instance_exec", &block)
    send(:"temporary method for instance_exec", *arg)
  end unless Object.method_defined?(:instance_exec)

  # Standard in ruby 1.8.7. See official documentation[http://ruby-doc.org/core-1.9/classes/Object.html]
  def tap
    yield self
    self
  end unless method_defined? :tap

end

# Loop. Standard in ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Object.html]
unless Object.const_defined? :StopIteration
  class StopIteration < IndexError; end

  module Kernel
    def loop_with_stop_iteration(&block)
      loop_without_stop_iteration(&block)
    rescue StopIteration
      # ignore silently
    end
    Backports.alias_method_chain self, :loop, :stop_iteration
  end
end

require 'enumerator'
# Must be defined outside of Kernel for jruby, see http://jira.codehaus.org/browse/JRUBY-3609
Enumerator = Enumerable::Enumerator unless Kernel.const_defined? :Enumerator # Standard in ruby 1.9

module Kernel

  def __callee__
    caller(1).first[/`(.*)'/,1].try(:to_sym)
  end unless (__callee__ || true rescue false)

  alias_method :__method__, :__callee__  unless (__method__ || true rescue false)

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Object.html]
  def define_singleton_method(*args, &block)
    class << self
      self
    end.send(:define_method, *args, &block)
  end unless method_defined? :define_singleton_method

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Object.html]
  def instance_exec(*arg, &block)
    define_singleton_method(:"temporary method for instance_exec", &block)
    send(:"temporary method for instance_exec", *arg)
  end unless method_defined? :instance_exec

  # Loop. Standard in ruby 1.8.7. See official documentation[http://ruby-doc.org/core-1.9/classes/Object.html]
  unless const_defined? :StopIteration
    class StopIteration < IndexError; end

    def loop_with_stop_iteration(&block)
      loop_without_stop_iteration(&block)
    rescue StopIteration
      # ignore silently
    end
    alias_method_chain :loop, :stop_iteration
  end

  # Standard in ruby 1.8.7. See official documentation[http://ruby-doc.org/core-1.9/classes/Object.html]
  def tap
    yield self
    self
  end unless method_defined? :tap

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/Object.html]
  def try(method_id, *args, &block)
    send(method_id, *args, &block) unless self.nil? #todo: check new def
  end unless method_defined? :try

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/Object.html]
  def returning(obj)
    yield obj
    obj
  end unless method_defined? :returning

end
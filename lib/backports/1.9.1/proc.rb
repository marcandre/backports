unless Proc.method_defined? :lambda?
  class Proc
    # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Proc.html]
    def lambda?
      !!@is_lambda
    end
  end

  class Method
    def to_proc_with_lambda_tracking
      proc = to_proc_without_lambda_tracking
      proc.instance_variable_set :@is_lambda, true
      proc
    end
    Backports.alias_method_chain self, :to_proc, :lambda_tracking
  end

  module Kernel
    def lambda_with_lambda_tracking(&block)
      Backports.track_lambda block, lambda_without_lambda_tracking(&block), true
    end

    def proc_with_lambda_tracking(&block)
      Backports.track_lambda block, proc_without_lambda_tracking(&block)
    end

    Backports.alias_method_chain self, :lambda, :lambda_tracking
    Backports.alias_method_chain self, :proc, :lambda_tracking
  end
end

class Proc
  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Proc.html]
  def curry(argc = nil)
    min_argc = arity < 0 ? -arity - 1 : arity
    argc ||= min_argc
    if lambda? and arity < 0 ? argc < min_argc : argc != arity
      raise ArgumentError, "wrong number of arguments (#{argc} for #{min_argc})"
    end
    creator = lambda? ? :lambda : :proc
    block = send(creator) do |*args|
      if args.count >= argc
        call(*args)
      else
        send(creator) do |*more_args|
          args += more_args
          block.call(*args)
        end
      end
    end
  end unless method_defined? :curry

  alias_method :===, :call unless Proc.new{true} === 42
end

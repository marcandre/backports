unless Proc.method_defined? :lambda?
  require 'backports/tools'

  class Proc
    # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Proc.html]
    def lambda?
      @is_lambda = nil unless defined?(@is_lambda) # Ruby 1.8 in verbose mode complains about uninitialized instance variables...
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

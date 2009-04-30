module Kernel
  unless const_defined? :StopIteration
    
    class StopIteration < IndexError; end

    def loop_with_stop_iteration(&block)
      loop_without_stop_iteration(&block)
    rescue StopIteration
      # ignore silently
    end
    alias_method_chain :loop, :stop_iteration
    
  end
  
  def __callee__
    caller(1).first[/`(.*)'/,1].try(:to_sym)
  end unless (__callee__ || true rescue false)
  
  alias_method :__method__, :__callee__  unless (__method__ || true rescue false)
end
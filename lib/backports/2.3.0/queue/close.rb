unless Queue.method_defined? :close
  require 'backports/tools/alias_method_chain'

  class ClosedQueueError < StopIteration
  end

  class Queue
    CLOSE_MESSAGE = Object.new

    def push_with_close(arg)
      raise ClosedQueueError, 'queue closed' if closed?

      push_without_close(arg)
    end
    Backports.alias_method_chain self, :push, :close
    alias_method :<<, :push
    alias_method :enq, :push

    def pop_with_close(non_block = false)
      begin
        r = pop_without_close(non_block || closed?)

        r unless CLOSE_MESSAGE == r
      rescue ThreadError
        raise if non_block || !closed?
      end
    end
    Backports.alias_method_chain self, :pop, :close

    alias_method :shift, :pop
    alias_method :deq, :pop

    def close
      @closed = true
      2.times do
        Thread.pass
        num_waiting.times do
          push_without_close CLOSE_MESSAGE
        end
      end
      self
    end

    def closed?
      !!defined?(@closed)
    end
  end
end

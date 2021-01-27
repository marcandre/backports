# shareable_constant_value: literal

require_relative 'filtered_queue'

module Backports
  class Ractor
    # Standard ::Queue but raises if popping and closed
    class BaseQueue < FilteredQueue
      ClosedQueueError = Ractor::ClosedError

      # yields message (if any)
      def pop_non_blocking
        yield pop(timeout: 0)
      rescue TimeoutError
        nil
      end
    end

    class IncomingQueue < BaseQueue
      TYPE = :incoming

      protected def reenter
        raise Ractor::Error, 'Can not reenter'
      end
    end

    # * Wraps exception
    # * Add `ack: ` to push (blocking)
    class OutgoingQueue < BaseQueue
      TYPE = :outgoing

      WrappedException = ::Struct.new(:exception, :ractor)

      def initialize
        @ack_queue = ::Queue.new
        super
      end

      def pop(timeout: nil, ack: true)
        r = super(timeout: timeout)
        @ack_queue << :done if ack
        raise r.exception if WrappedException === r

        r
      end

      def close(how = :hard)
        super()
        return if how == :soft

        clear
        @ack_queue.close
      end

      def push(obj, ack:)
        super(obj)
        if ack
          r = @ack_queue.pop # block until popped
          raise ClosedError, "The #{self.class::TYPE}-port is already closed" unless r == :done
        end
        self
      end
    end
    private_constant :BaseQueue, :OutgoingQueue, :IncomingQueue
  end
end

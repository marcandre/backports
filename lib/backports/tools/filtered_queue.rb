module Backports
  class FilteredQueue
    CONSUME_ON_REENTRY = true
    CONSUME_ON_ESCAPE = true

    class ClosedQueueError < ::ClosedQueueError
    end
    class TimeoutError < ::ThreadError
    end

    class Message
      # Not using Struct as we want comparision by identity
      attr_reader :value
      attr_accessor :reserved

      def initialize(value)
        @value = value
        @reserved = false
      end
    end
    private_constant :Message

    # Like ::Queue, but with
    # - filtering
    # - timeout
    # - raises on closed queues

    # Timeout processing based on https://spin.atomicobject.com/2017/06/28/queue-pop-with-timeout-fixed/
    def initialize
      @mutex = ::Mutex.new
      @queue = []
      @closed = false
      @received = ::ConditionVariable.new
    end

    def close
      @mutex.synchronize do
        @closed = true
        @received.broadcast
      end
      self
    end

    def <<(x)
      @mutex.synchronize do
        ensure_open
        @queue << Message.new(x)
        @received.signal
      end
      self
    end

    def pop(timeout: nil, &block)
      msg = nil
      exclude = [] if block # exclusion list of messages rejected by this call
      timeout_time = timeout + Time.now.to_f if timeout
      while true do
        @mutex.synchronize do
          msg = acquire!(timeout_time, exclude)
          return consume!(msg).value unless block
        end
        return msg.value if filter?(msg, &block)
      end
    end

    def empty?
      avail = @mutex.synchronize do
        available!
      end

      !avail
    end

    protected def timeout_value
      raise self.class::TimeoutError, "timeout elapsed"
    end

    protected def closed_queue_value
      ensure_open
    end

    ### private section
    #
    # bang methods require synchronization

    # @returns:
    # * true if message consumed (block result truthy or due to reentrant call)
    # * false if rejected
    private def filter?(msg)
      consume = self.class::CONSUME_ON_ESCAPE
      begin
        reentered = consume_on_reentry(msg) do
          consume = !!(yield msg.value)
        end
        reentered ? self.class::CONSUME_ON_REENTRY : consume
      ensure
        commit(msg, consume) unless reentered
      end
    end

    # @returns msg
    private def consume!(msg)
      @queue.delete(msg)
    end

    private def reject!(msg)
      msg.reserved = false
      @received.broadcast
    end

    private def commit(msg, consume)
      @mutex.synchronize do
        if consume
          consume!(msg)
        else
          reject!(msg)
        end
      end
    end

    private def consume_on_reentry(msg)
      q_map = current_filtered_queues
      if (outer_msg = q_map[self])
        commit(outer_msg, self.class::CONSUME_ON_REENTRY)
      end
      q_map[self] = msg
      begin
        yield
      ensure
        reentered = (q_map[self] == nil)
        q_map[self] = nil
      end
      reentered
    end

    # @returns WeakMap { FilteredQueue => Message }
    private def current_filtered_queues
      t = Thread.current
      t.thread_variable_get(:backports_currently_filtered_queues) or
        t.thread_variable_set(:backports_currently_filtered_queues, ::ObjectSpace::WeakMap.new)
    end

    # private methods assume @mutex synchonized
    # adds to exclude list
    private def acquire!(timeout_time, exclude = nil)
      while true do
        if (msg = available!(exclude))
          msg.reserved = true
          exclude << msg if exclude
          return msg
        end
        return closed_queue_value if @closed
        # wait for element or timeout
        if timeout_time
          remaining_time = timeout_time - ::Time.now.to_f
          return timeout_value if remaining_time <= 0
        end
        @received.wait(@mutex, remaining_time)
      end
    end

    private def available!(exclude = nil)
      @queue.find do |msg|
        next if exclude&.include?(msg)
        !msg.reserved
      end
    end

    private def ensure_open
      raise self.class::ClosedQueueError, 'queue closed' if @closed
    end
  end
end

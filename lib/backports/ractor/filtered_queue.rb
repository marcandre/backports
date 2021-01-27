# shareable_constant_value: literal

module Backports
  # Like ::Queue, but with
  # - filtering
  # - timeout
  # - raises on closed queues
  #
  # Independent from other Ractor related backports.
  class FilteredQueue
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

    attr_reader :num_waiting

    # Timeout processing based on https://spin.atomicobject.com/2017/06/28/queue-pop-with-timeout-fixed/
    def initialize
      @mutex = ::Mutex.new
      @queue = []
      @closed = false
      @received = ::ConditionVariable.new
      @num_waiting = 0
    end

    def close
      @mutex.synchronize do
        @closed = true
        @received.broadcast
      end
      self
    end

    def closed?
      @closed
    end

    def <<(x)
      @mutex.synchronize do
        ensure_open
        @queue << Message.new(x)
        @received.signal
      end
      self
    end
    alias_method :push, :<<

    def clear
      @mutex.synchronize do
        @queue.clear
      end
      self
    end

    def pop(timeout: nil, &block)
      msg = nil
      exclude = [] if block # exclusion list of messages rejected by this call
      timeout_time = timeout + Time.now.to_f if timeout
      while true do # rubocop:disable Style/InfiniteLoop, Style/WhileUntilDo
        @mutex.synchronize do
          reenter if reentrant?
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

    # @return if outer message should be consumed or not
    protected def reenter
      true
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
        reentered ? reenter : consume
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
        commit(outer_msg, reenter)
      end
      q_map[self] = msg
      begin
        yield
      ensure
        reentered = !q_map.delete(self)
      end
      reentered
    end

    private def reentrant?
      !!current_filtered_queues[self]
    end

    # @returns Hash { FilteredQueue => Message }
    private def current_filtered_queues
      t = Thread.current
      t.thread_variable_get(:backports_currently_filtered_queues) or
        t.thread_variable_set(:backports_currently_filtered_queues, {}.compare_by_identity)
    end

    # private methods assume @mutex synchonized
    # adds to exclude list
    private def acquire!(timeout_time, exclude = nil)
      while true do # rubocop:disable Style/InfiniteLoop, Style/WhileUntilDo
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
        begin
          @num_waiting += 1
          @received.wait(@mutex, remaining_time)
        ensure
          @num_waiting -= 1
        end
      end
    end

    private def available!(exclude = nil)
      @queue.find do |msg|
        next if exclude && exclude.include?(msg)
        !msg.reserved
      end
    end

    private def ensure_open
      raise self.class::ClosedQueueError, 'queue closed' if @closed
    end
  end
end

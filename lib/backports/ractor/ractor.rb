# shareable_constant_value: literal

# Ruby 2.0+ backport of `Ractor` class
# Extra private methods and instance variables all start with `ractor_`
module Backports
  class Ractor
    require_relative '../tools/arguments'

    require_relative 'cloner'
    require_relative 'errors'
    require_relative 'queues'
    require_relative 'sharing'

    RactorThreadGroups = ::ObjectSpace::WeakMap.new # ThreadGroup => Ractor
    private_constant :RactorThreadGroups
    # Implementation notes
    #
    # Uses one `Thread` for each `Ractor`, as well as queues for communication
    #
    # The incoming queue is strict: contrary to standard queue, you can't pop from an empty closed queue.
    # Since standard queues return `nil` is those conditions, we wrap/unwrap `nil` values and consider
    # all `nil` values to be results of closed queues. `ClosedQueueError` are re-raised as `Ractor::ClosedError`
    #
    # The outgoing queue is strict and blocking. Same wrapping / raising as incoming,
    # with an extra queue to acknowledge when a value has been read (or if the port is closed while waiting).
    #
    # The last result is a bit tricky as it needs to be pushed on the outgoing queue but can not be blocking.
    # For this, we "soft close" the outgoing port.

    def initialize(*args, &block)
      @ractor_incoming_queue = IncomingQueue.new
      @ractor_outgoing_queue = OutgoingQueue.new
      raise ::ArgumentError, 'must be called with a block' unless block

      kw = args.last
      if kw.is_a?(::Hash) && kw.size == 1 && kw.key?(:name)
        args.pop
        name = kw[:name]
      end
      @ractor_name = name && Backports.coerce_to_str(name)

      @id = Ractor.ractor_next_id
      if Ractor.main == nil # then initializing main Ractor
        @ractor_thread = ::Thread.current
        @ractor_origin = nil
        @ractor_thread.thread_variable_set(:backports_ractor, self)
      else
        @ractor_origin = caller(1, 1).first.split(':in `').first

        args.map! { |a| Ractor.ractor_isolate(a, false) }
        ractor_thread_start(args, block)
      end
    end

    private def ractor_thread_start(args, block)
      ::Thread.new do
        @ractor_thread = ::Thread.current
        @ractor_thread_group = ::ThreadGroup.new
        RactorThreadGroups[@ractor_thread_group] = self
        @ractor_thread_group.add(@ractor_thread)
        ::Thread.current.thread_variable_set(:backports_ractor, self)
        result = nil
        begin
          result = instance_exec(*args, &block)
        rescue ::Exception => err # rubocop:disable Lint/RescueException
          begin
            raise RemoteError, "thrown by remote Ractor: #{err.message}"
          rescue RemoteError => e # Hack to create exception with `cause`
            result = OutgoingQueue::WrappedException.new(e)
          end
        ensure
          ractor_thread_terminate(result)
        end
      end
    end

    private def ractor_thread_terminate(result)
      begin
        ractor_outgoing_queue.push(result, ack: false) unless ractor_outgoing_queue.closed?
      rescue ::ClosedQueueError
        return # ignore
      end
      ractor_incoming_queue.close
      ractor_outgoing_queue.close(:soft)
    ensure
      # TODO: synchronize?
      @ractor_thread_group.list.each do |thread|
        thread.kill unless thread == Thread.current
      end
    end

    def send(obj, move: false)
      ractor_incoming_queue << Ractor.ractor_isolate(obj, move)
      self
    rescue ::ClosedQueueError
      raise ClosedError, 'The incoming-port is already closed'
    end
    alias_method :<<, :send

    def take
      ractor_outgoing_queue.pop(ack: true)
    end

    def name
      @ractor_name
    end

    RACTOR_STATE = {
      'sleep' => 'blocking',
      'run' => 'running',
      'aborting' => 'aborting',
      false => 'terminated',
      nil => 'terminated',
    }.freeze
    private_constant :RACTOR_STATE

    def inspect
      state = RACTOR_STATE[@ractor_thread ? @ractor_thread.status : 'run']
      info = [
        "Ractor:##{@id}",
        name,
        @ractor_origin,
        state,
      ].compact.join(' ')

      "#<#{info}>"
    end

    def close_incoming
      r = ractor_incoming_queue.closed?
      ractor_incoming_queue.close
      r
    end

    def close_outgoing
      r = ractor_outgoing_queue.closed?
      ractor_outgoing_queue.close
      r
    end

    private def receive
      ractor_incoming_queue.pop
    end

    private def receive_if(&block)
      raise ::ArgumentError, 'no block given' unless block
      ractor_incoming_queue.pop(&block)
    end

    def [](key)
      Ractor.current.ractor_locals[key]
    end

    def []=(key, value)
      Ractor.current.ractor_locals[key] = value
    end

    # @api private
    def ractor_locals
      @ractor_locals ||= {}.compare_by_identity
    end

    class << self
      def yield(value, move: false)
        value = ractor_isolate(value, move)
        current.ractor_outgoing_queue.push(value, ack: true)
      rescue ::ClosedQueueError
        raise ClosedError, 'The outgoing-port is already closed'
      end

      def receive
        current.__send__(:receive)
      end
      alias_method :recv, :receive

      def receive_if(&block)
        current.__send__(:receive_if, &block)
      end

      def select(*ractors, yield_value: not_given = true, move: false)
        cur = Ractor.current
        queues = ractors.map do |r|
          r == cur ? r.ractor_incoming_queue : r.ractor_outgoing_queue
        end
        if !not_given
          out = current.ractor_outgoing_queue
          yield_value = ractor_isolate(yield_value, move)
        elsif ractors.empty?
          raise ::ArgumentError, 'specify at least one ractor or `yield_value`'
        end

        while true # rubocop:disable Style/InfiniteLoop
                    # Don't `loop`, in case of `ClosedError` (not that there should be any)
          queues.each_with_index do |q, i|
            q.pop_non_blocking do |val|
              r = ractors[i]
              return [r == cur ? :receive : r, val]
            end
          end

          if out && out.num_waiting > 0
            # Not quite atomic...
            out.push(yield_value, ack: true)
            return [:yield, nil]
          end

          sleep(0.001)
        end
      end

      def make_shareable(obj)
        return obj if ractor_check_shareability?(obj, true)

        raise Ractor::Error, '#freeze does not freeze object correctly'
      end

      def shareable?(obj)
        ractor_check_shareability?(obj, false)
      end

      def current
        ::Thread.current.thread_variable_get(:backports_ractor) ||
          ::Thread.current.thread_variable_set(:backports_ractor, ractor_find_current)
      end

      def count
        ::ObjectSpace.each_object(Ractor).count(&:ractor_live?)
      end

      # @api private
      def ractor_reset
        ::ObjectSpace.each_object(Ractor).each do |r|
          next if r == Ractor.current
          next unless (th = r.ractor_thread)

          th.kill
          th.join
        end
        Ractor.current.ractor_incoming_queue.clear
      end

      # @api private
      def ractor_next_id
        @id ||= 0
        @id += 1
      end

      attr_reader :main

      private def ractor_init
        @ractor_shareable = ::ObjectSpace::WeakMap.new
        @main = Ractor.new { nil }
        RactorThreadGroups[::ThreadGroup::Default] = @main
      end

      private def ractor_find_current
        RactorThreadGroups[Thread.current.group]
      end
    end

    # @api private
    def ractor_live?
      !defined?(@ractor_thread) || # May happen if `count` is called from another thread before `initialize` has completed
        @ractor_thread.status
    end

    # @api private
    attr_reader :ractor_outgoing_queue, :ractor_incoming_queue, :ractor_thread

    ractor_init
  end
end

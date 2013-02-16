class TracePoint

  def self.trace(*events, &proc)
    trace = new(*events, &proc)
    trace.enable
  end

  def self.tracepoints #:nodoc:
    @tracepoints ||= []
  end

  def self.switch! #:nodoc:
    if @tracepoints.empty?
      set_trace_func(nil)
    else
      bb_stack = []
      fn = lambda do |e, f, l, m, b, k|
        # TODO: This condition likely needs to be refined. The point is to prevent
        #       tracing of the code that does the tracing itself, which a) no one
        #       is interested in and b) prevents possbile infinite recursions.
        unless $__trace__ or k === TracePoint or (k == Kernel && m == :set_trace_func)
          $__trace__ = [e, f, l, m, b, k]
          #(p e, f, l, m, b, k, bb_stack; puts "---") if $DEBUG
          if ['call','c-call','b-call','class'].include?(e)
            bb_stack << b
          elsif ['return','c-return','b-return','end'].include?(e)
            bb = bb_stack.pop
          end
          b = bb if ! b    # this sucks!
          @tracepoints.each do |tp|
            tp.send(:call_with, e, f, l, m, k, b, bb)
          end
          $__trace__ = nil
        end
      end
      set_trace_func(fn)
    end
  end

  def initialize(*events, &proc)
    @events = events
    @proc = proc || raise(ArgumentError, "trace procedure required")
  end

  def enabled?
    @enabled
  end

  def enable
    if block_given? && !enabled?
      enable
      result = yield
      disable
      result
    else
      previous_state = enabled?
      @enabled = true
      self.class.tracepoints << self
      self.class.switch!
      previous_state
    end
  end

  def disable
    if block_given? && enabled?
      disable
      result = yield
      enable
      result
    else
      previous_state = enabled?
      @enabled = false
      self.class.tracepoints.delete self
      self.class.switch!
      previous_state
    end
  end

  attr_reader :event

  attr_reader :path

  attr_reader :lineno

  attr_reader :binding

  # The previous binding.
  #
  # Note: This is the only *extra* feature that is not currently
  #       part of Ruby 2.0's implementation. It has proven useful
  #       so it's been kept. It would be nice if ko1 (Koichi Sasada)
  #       would agree to include in Ruby's API.
  #
  # Returns [Binding]
  attr_reader :prior_binding

  # Alias for #prior_binding.
  #
  # Returns [Binding]
  def binding_of_caller
    @prior_binding
  end

  def self
    @binding.self
  end

  def defined_class
    binding.eval{ self.class }
  end

  def method_id
    @method
  end

  # TODO: How to get raised exception?
  def raised_exception
    raise NotImplementedError, "Please constribute a patch if you know how to fix."

    case event
    when :raise
      @klass
    end
  end

  # TODO: How to get the return value?
  def return_value
    raise NotImplementedError, "Please constribute a patch if you know how to fix."

    case event
    when :return, :c_return, :b_return
      self
    end
  end

  #--
  # TODO: Ruby's code also had `RUBY_EVENT_SPECIFIED_LINE` with :line,
  #       but I have not idea what that is.
  #++

  def inspect
    case event
    when :line
		  if method_id.nil?
        "#<TracePoint:%s@%s:%d>" % [event, path, lineno]
      else
        "#<TracePoint:%s@%s:%d in `%s'>" % [event, path, lineno, method_id]
      end
    when :call, :c_call, :return, :c_return
      "#<TracePoint:%s `%s'@%s:%d>" % [event, method_id, path, lineno]
    when :thread_begin, :thread_end
	    "#<TracePoint:%s %s>" % [event, self]
    else
      "#<TracePoint:%s@%s:%d>" % [event, path, lineno]
    end
  end

protected

  def call_with(event, file, line, method, klass, bind, prebind=nil) #:nodoc:
    set(event, file, line, method, klass, bind, prebind)
    @proc.call(self)
  end

  def set(event, path, line, method, klass, bind, prebind=nil)  #:nodoc:
    @event   = event.to_sym
    @path    = path
    @lineno  = line
    @method  = method
    @klass   = klass
    @binding = bind || TOPLEVEL_BINDING  # TODO: Correct ?
    @prior_binding = prebind || TOPLEVEL_BINDING  # TODO: or leave nil ?
  end
end


class Binding

  unless method_defined?(:eval) # 1.8.7+
    def eval(code)
      Kernel.eval(code, self)
    end
  end

  unless method_defined?(:self) # 1.9+ ?
    def self()
      @_self ||= eval("self")
    end
  end

end

# Copyright (c) 2005,2013 Thomas Sawyer (BSD-2-Clause License)

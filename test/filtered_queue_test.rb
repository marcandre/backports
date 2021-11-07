require './test/test_helper'
require 'backports/2.3.0/queue/close'
require 'backports/ractor/filtered_queue'

class FilteredQueueTest < Test::Unit::TestCase
  def setup
    @q = ::Backports::FilteredQueue.new
  end

  def assert_remains(*values)
    remain = []
    remain << @q.pop until @q.empty?
    assert_equal values, remain
  end

  def test_basic
    @q << 1 << 2
    x = []
    x << @q.pop
    @q << 3
    x << @q.pop
    x << @q.pop
    t = Thread.new { sleep(0.1); @q << 4 << 5}
    x << @q.pop
    t.join
    assert_equal([1,2,3,4], x)
    assert_remains(5)
  end

  def test_close
    Thread.new { sleep(0.2); @q.close }
    assert_raise(::Backports::FilteredQueue::ClosedQueueError) { @q.pop }
    assert_raise(::Backports::FilteredQueue::ClosedQueueError) { @q.pop }
    assert_raise(::Backports::FilteredQueue::ClosedQueueError) { @q.pop(timeout: 0) }
    assert_raise(::Backports::FilteredQueue::ClosedQueueError) { @q << 42 }
  end

  def test_close_after
    @q << 1 << 2
    @q.close
    assert_equal(1, @q.pop)
    assert_equal(2, @q.pop)
    assert_raise(::Backports::FilteredQueue::ClosedQueueError) { @q.pop }
  end

  def test_timeout
    assert_raise(::Backports::FilteredQueue::TimeoutError) { @q.pop(timeout: 0) }
    Thread.new { sleep(0.2); @q << :done }
    assert_raise(::Backports::FilteredQueue::TimeoutError) { @q.pop(timeout: 0.1) }
    assert_equal(:done, @q.pop(timeout: 0.2))
  end

  def assert_eventually_equal(value)
    100.times do
      return true if value == yield
      sleep(0.01)
    end
    assert value == yield
  end

  def test_filter
    # send 0 to 7 to queue, with filters for 0 to 2.
    # start queue with `before` elements already present
    (0..4).each do |before|
      other = [4,5,6,7]
      calls = 0
      before.times { @q << other.shift }
      t = 3.times.map do |i|
        Thread.new do
          @q.pop { |n| calls += 1; Thread.pass; n == i }
        end
      end
      Thread.pass
      other.each { |i| @q << i }
      assert_eventually_equal(3) {@q.num_waiting}
      assert_eventually_equal(3 * 4) {calls}
      @q << :extra
      assert_eventually_equal(3 * 5) {calls}
      @q << 0 << 1 << 2 << 3
      t.each(&:join)
      assert_equal 0, @q.num_waiting
      assert_remains 4, 5, 6, 7, :extra, 3
    end
  end

  def test_non_standard_filters
    @q << 1 << 2 << 3
    @q.pop { break }
    @q.pop { raise 'err' } rescue nil
    assert_remains 3
  end

  def test_recursive_filter
    [
      [0, :other],
      [:other, 0],
    ].each do |a, b|
      @q << :first << a << b << :last
      inner = nil
      a = @q.pop do
        inner = @q.pop { |x| x == 0}
        false # => ignored
      end
      assert_equal :first, a
      assert_equal 0, inner
      assert_remains :other, :last
    end
  end
end

if RUBY_VERSION < '3'
  require './test/test_helper'
  require './lib/backports/3.0.0/ractor.rb'

  def thread_eval
    r = nil
    Thread.new { r = yield }.join
    r
  end

  def storage_change(to, key: :foo)
    current = Ractor.current[key]
    Ractor.current[key] = to
    {current => Ractor.current[key]}
  end

  class ExtraRactorTest < Test::Unit::TestCase
    def assert_shareable(*objects)
      check_shareability(objects, true)
    end

    def assert_not_shareable(*objects, &block)
      check_shareability(objects, false)
    end

    def check_shareability(objects, shareable)
      objects.each do |obj|
        assert_equal shareable, obj.object_id == Ractor.new(obj, &:object_id).take
        assert_equal shareable, obj.object_id == Ractor.new([obj]) { |x, | x.object_id }.take
        assert_equal obj.frozen?, Ractor.new(obj, &:frozen?).take
        assert_equal obj.frozen?, Ractor.new([obj]) { |x, | x.frozen? } .take
        assert_equal shareable, Ractor.shareable?(obj)
      end
    end

    def test_copy_only_copies_when_needed
      r = Ractor.new {}
      assert_shareable(r, 42, 4.2, 2..4, false, true, nil, 'abc'.freeze)

      assert_not_shareable('abc'.dup, [], {})

      a = []; b = [a].freeze; c = [a].freeze; a << c
      assert_not_shareable(a, b, c)

      a.freeze
      assert_shareable(a, b, c)

      h = {a: 1, b: 2}
      assert_not_shareable(h)
      assert_shareable(h.freeze)

      h = {a: [1, 2, 3], b: 2}
      assert_not_shareable(h)
      assert_not_shareable(h.freeze)
      h[:a].freeze
      assert_shareable(h)
    end

    def make_shareable_fail
      o = Object.new
      def o.freeze; self; end
      assert_raise(Ractor::Error) { Ractor.make_shareable(o) }
    end

    def test_main
      assert_same(Ractor.current, Ractor.main)
      assert_same(Ractor.current, thread_eval { Ractor.main })
      assert_same(thread_eval{ Ractor.current }, Ractor.main)

      r = Ractor.new do
        [ Ractor.main, thread_eval{ Ractor.main },
          Ractor.current, thread_eval{ Ractor.current }]
      end
      main, main2, current, current2 = r.take
      assert_same(r, current)
      assert_same(r, current2)
      assert_same(main, Ractor.main)
      assert_same(main2, Ractor.main)
    end

    def assert_storage(to, from: nil, key: :foo)
      assert_equal from, Ractor.current[key]
      Ractor.current[key] = to
      assert_equal to, Ractor.current[key]
    end

    def test_local_storage
      assert_equal({nil => :first}, storage_change(:first))
      ractor = Ractor.new {
        [storage_change(:in_ractor), thread_eval { storage_change(:in_ractor_thread) }]
      }
      a, b = ractor.take
      assert_equal({nil => :in_ractor}, a)
      assert_equal({in_ractor: :in_ractor_thread}, b)

      assert_equal({first: :in_thread}, thread_eval { storage_change(:in_thread) })
      assert_equal({nil => :different}, storage_change(:different, key: :other))
      assert_equal(:in_thread, Ractor.current[:foo])
      assert_equal(:in_thread, ractor[:foo])
    end

    def test_name
      #<Ractor:#2 (irb):1 blocking>
      assert_match(/#<Ractor:#\d+ #{__FILE__}:#{__LINE__} (blocking|running)>/, ::Ractor.new{ sleep(0.01) }.inspect)
      assert_equal('Ractor', ::Ractor.name)
    end

    def test_namespaced_include
      cmd = "ruby -r #{__dir__}/../lib/backports/ractor/ractor -e 'p [defined?(Ractor), Backports::Ractor.new { 42 }.take]'"
      puts cmd
      r = `#{cmd}`.chomp
      assert_equal '[nil, 42]', r
    end if RUBY_VERSION >= '2.3'
  end
end

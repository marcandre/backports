require 'test/unit'

class TestBackport < Test::Unit::TestCase

  def class_signature(klass)
    Hash[
      klass.instance_methods.map{|m| [m, klass.instance_method(m)] } +
      klass.methods.map{|m| [".#{m}", klass.method(m) ]}
    ]
  end

  CLASSES = [Array, Binding, Dir, Enumerable, Fixnum, Float, GC,
      Hash, Integer, IO, Kernel, Math, MatchData, Method, Module, Numeric,
      ObjectSpace, Proc, Process, Range, Regexp, String, Struct, Symbol] +
    [ENV, ARGF].map{|obj| class << obj; self; end }

  case RUBY_VERSION
    when '1.8.6'
    when '1.8.7'
      CLASSES << Enumerable::Enumerator
    else
      CLASSES << Enumerator
  end

  def digest
    Hash[
      CLASSES.map { |klass| [klass, class_signature(klass)] }
    ]
  end

  def digest_delta(before, after)
    delta = {}
    before.each do |klass, methods|
      compare = after[klass]
      d = methods.map do |name, unbound|
        name unless unbound == compare[name]
      end
      d.compact!
      delta[klass] = d unless d.empty?
    end
    delta unless delta.empty?
  end

  def test_backports_wont_override_unnecessarily
    before = digest
    require "./lib/backports/#{RUBY_VERSION}"
    after = digest
    assert_nil digest_delta(before, after)
  end
end


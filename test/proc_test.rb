require 'test_helper'

class ProcTest < Test::Unit::TestCase
  # method names correspond with Ruby docs
  def n(&b) b.lambda? end
  def m() end

  class C
    define_method(:d) {}
    define_method(:e, &proc {})
  end

  context "Proc" do
    context "#lambda?" do
      context "basic usage" do
        should "conform to docs" do
          assert lambda {}.lambda?
          assert !proc {}.lambda?
          assert !Proc.new {}.lambda?
        end
      end

      context "propagation" do
        should "conform to docs" do
          assert lambda(&lambda {}).lambda?
          assert proc(&lambda {}).lambda?
          assert Proc.new(&lambda {}).lambda?
        end
      end

      context "blocks passed to methods" do
        should "conform to docs" do
          assert !n { }
          assert n(&lambda {})
          assert !n(&proc {})
          assert !n(&Proc.new {})
        end
      end

      context "Method#to_proc" do
        should "conform to docs" do
          assert method(:m).to_proc.lambda?
          assert n(&method(:m))
          assert n(&method(:m).to_proc)
          assert C.new.method(:d).to_proc.lambda?
          assert C.new.method(:e).to_proc.lambda?
        end
      end
    end

    context "#curry" do
      context "proc" do
        context "no arguments" do
          should "conform to docs" do
            b = proc { :foo }
            assert_equal :foo, b.curry[]
          end
        end

        context "arity > 0" do
          should "conform to docs" do
            b = Proc.new {|x, y, z| (x||0) + (y||0) + (z||0) }
            assert_equal 6, b.curry[1][2][3]
            assert_equal 6, b.curry[1, 2][3, 4]
            assert_equal 6, b.curry(5)[1][2][3][4][5]
            assert_equal 6, b.curry(5)[1, 2][3, 4][5]
            assert_equal 1, b.curry(1)[1]
          end
        end

        context "arity < 0" do
          should "conform to docs" do
            b = Proc.new {|x, y, z, *w| (x||0) + (y||0) + (z||0) + w.inject(0, &:+) }
            assert_equal 6,  b.curry[1][2][3]
            assert_equal 10, b.curry[1, 2][3, 4]
            assert_equal 15, b.curry(5)[1][2][3][4][5]
            assert_equal 15, b.curry(5)[1, 2][3, 4][5]
            assert_equal 1,  b.curry(1)[1]
          end
        end
      end

      context "lambda" do
        context "arity > 0" do
          should "conform to docs" do
            b = lambda {|x, y, z| (x||0) + (y||0) + (z||0) }
            assert_equal 6, b.curry[1][2][3]
            assert_raises(ArgumentError) { b.curry[1, 2][3, 4] }
            assert_raises(ArgumentError) { b.curry(5) }
            assert_raises(ArgumentError) { b.curry(1) }
          end
        end

        context "arity < 0" do
          should "conform to docs" do
            b = lambda {|x, y, z, *w| (x||0) + (y||0) + (z||0) + w.inject(0, &:+) }
            assert_equal 6,  b.curry[1][2][3]
            assert_equal 10, b.curry[1, 2][3, 4]
            assert_equal 15, b.curry(5)[1][2][3][4][5]
            assert_equal 15, b.curry(5)[1, 2][3, 4][5]
            assert_raises(ArgumentError) { b.curry(1) }
          end
        end
      end
    end
  end
end
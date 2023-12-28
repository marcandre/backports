require './test/test_helper'
require 'backports/3.3.0/range/overlap'

class OverlapTest < Test::Unit::TestCase
  def test_overlap?
    assert_not_operator(0..2, :overlap?, -2..-1)
    assert_not_operator(0..2, :overlap?, -2...0)
    assert_operator(0..2, :overlap?, -1..0)
    assert_operator(0..2, :overlap?, 1..2)
    assert_operator(0..2, :overlap?, 2..3)
    assert_not_operator(0..2, :overlap?, 3..4)
    assert_not_operator(0...2, :overlap?, 2..3)

    assert_operator(nil..0, :overlap?, -1..0)
    assert_operator(nil...0, :overlap?, -1..0)
    assert_operator(nil..0, :overlap?, 0..1)
    assert_operator(nil..0, :overlap?, nil..1)
    assert_not_operator(nil..0, :overlap?, 1..2)
    assert_not_operator(nil...0, :overlap?, 0..1)

    assert_not_operator(0..nil, :overlap?, -2..-1)
    assert_not_operator(0..nil, :overlap?, nil...0)
    assert_operator(0..nil, :overlap?, -1..0)
    assert_operator(0..nil, :overlap?, nil..0)
    assert_operator(0..nil, :overlap?, 0..1)
    assert_operator(0..nil, :overlap?, 1..2)
    assert_operator(0..nil, :overlap?, 1..nil)

    assert_not_operator((1..3), :overlap?, ('a'..'d'))

    assert_raise(TypeError) { (0..nil).overlap?(1) }
    assert_raise(TypeError) { (0..nil).overlap?(nil) }

    assert_operator((1..3), :overlap?, (2..4))
    assert_operator((1...3), :overlap?, (2..3))
    assert_operator((2..3), :overlap?, (1..2))
    assert_operator((nil..3), :overlap?, (3..nil))
    assert_operator((nil..nil), :overlap?, (3..nil))
    assert_operator((nil...nil), :overlap?, (nil..nil))

    assert_raise(TypeError) { (1..3).overlap?(1) }

    assert_not_operator((1..2), :overlap?, (2...2))
    assert_not_operator((2...2), :overlap?, (1..2))

    assert_not_operator((4..1), :overlap?, (2..3))
    assert_not_operator((4..1), :overlap?, (nil..3))
    assert_not_operator((4..1), :overlap?, (2..nil))

    assert_not_operator((1..4), :overlap?, (3..2))
    assert_not_operator((nil..4), :overlap?, (3..2))
    assert_not_operator((1..nil), :overlap?, (3..2))

    assert_not_operator((4..5), :overlap?, (2..3))
    assert_not_operator((4..5), :overlap?, (2...4))

    assert_not_operator((1..2), :overlap?, (3..4))
    assert_not_operator((1...3), :overlap?, (3..4))

    assert_not_operator((4..5), :overlap?, (2..3))
    assert_not_operator((4..5), :overlap?, (2...4))

    assert_not_operator((1..2), :overlap?, (3..4))
    assert_not_operator((1...3), :overlap?, (3..4))
    assert_not_operator((nil...3), :overlap?, (3..nil))
  end if ((nil..1) rescue false)
end

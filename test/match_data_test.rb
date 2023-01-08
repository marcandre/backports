# frozen_string_literal: false
require './test/test_helper'
require 'backports/3.2.0/match_data'

class MatchDataData < Test::Unit::TestCase
  def test_match_byteoffset_begin_end
    m = /(?<x>b..)/.match("foobarbaz")
    assert_equal(3, m.begin("x"))
    assert_equal(6, m.end("x"))
    assert_equal([3, 6], m.byteoffset("x"))
    assert_raise(IndexError) { m.byteoffset("y") }
    assert_raise(IndexError) { m.byteoffset(2) }
    assert_raise(IndexError) { m.begin(2) }
    assert_raise(IndexError) { m.end(2) }

    m = /(?<x>q..)?/.match("foobarbaz")
    assert_equal(nil, m.begin("x"))
    assert_equal(nil, m.end("x"))
    assert_equal([nil, nil], m.byteoffset("x"))

    m = /\A\u3042(.)(.)?(.)\z/.match("\u3042\u3043\u3044")
    assert_equal([3, 6], m.byteoffset(1))
    assert_equal([nil, nil], m.byteoffset(2))
    assert_equal([6, 9], m.byteoffset(3))
  end
end

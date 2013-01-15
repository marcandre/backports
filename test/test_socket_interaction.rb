require 'test/unit'
require 'socket'
require './lib/backports'

class TestSocketInteraction < Test::Unit::TestCase
  def test_interaction # Issue #67
    assert_equal nil, UDPSocket.open{}
  end
end

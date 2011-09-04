$bogus = []

module Kernel
  def require_with_bogus_extension(lib)
    $bogus << lib
    require_without_bogus_extension(lib)
  end
  alias_method :require_without_bogus_extension, :require
  alias_method :require, :require_with_bogus_extension

  if defined? BasicObject and BasicObject.superclass
    BasicObject.send :undef_method, :require
    BasicObject.send :undef_method, :require_with_bogus_extension
  end
end

require 'matrix'
require 'test_helper'


class StdLibLoadingTest < Test::Unit::TestCase
  context "StdLib" do
    should "load correctly after requiring backports" do
      path = File.expand_path("../../lib/backports/1.9.2/stdlib/set.rb", __FILE__)
      assert_equal false,  $LOADED_FEATURES.include?(path)
      assert_equal true,  require('set')
      assert_equal true,  $bogus.include?("set")
      assert_equal true,  $LOADED_FEATURES.include?(path)
      assert_equal false, require('set')
    end

    should "load correctly before requiring backports" do
      assert_equal true,  $bogus.include?("matrix")
      path = File.expand_path("../../lib/backports/1.9.2/stdlib/matrix.rb", __FILE__)
      assert_equal true,  $LOADED_FEATURES.include?(path)
      assert_equal false, require('matrix')
    end

    should "not interfere for libraries without backports" do
      assert_equal true,  require('dl')
      assert_equal false, require('dl')
    end

    if RUBY_VERSION >= "1.9"
      should 'not load "new libraries" when they already exist' do
        path = File.expand_path("../../lib/backports/1.9.1/stdlib_new/prime.rb", __FILE__)
        assert_equal true,  require('prime')
        assert_equal false, require('prime')
        assert_equal false, $LOADED_FEATURES.include?(path)
      end
    else
      should "load correctly new libraries" do
        assert_equal false, $LOADED_FEATURES.include?("prime.rb")
        assert_equal true,  require('prime')
        assert_equal true,  $LOADED_FEATURES.include?("prime.rb")
        assert_equal false, require('prime')
      end
    end
  end
end
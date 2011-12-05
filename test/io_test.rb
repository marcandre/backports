require 'test_helper'
require 'fileutils'

class IOTest < Test::Unit::TestCase
  TEST_DIR = File.expand_path('../io_test', __FILE__)

  context "IO" do
    setup do
      FileUtils.rm_rf TEST_DIR
      Dir.mkdir TEST_DIR
      @pwd = Dir.pwd
      Dir.chdir(TEST_DIR)
    end

    teardown do
      FileUtils.rm_rf TEST_DIR
      Dir.chdir @pwd
    end

    context "write" do
      should "create a missing file" do
        File.write("foo.txt", "")
        assert File.exist?("foo.txt")
      end

      should "write the given string to the file" do
        File.write("foo.txt", "bar")
        assert_equal "bar", File.read("foo.txt")
      end

      should "truncate by default" do
        File.write("foo.txt", "bar")
        File.write("foo.txt", "x")
        assert_equal "x", File.read("foo.txt")
      end

      should "not truncate if an offset is given" do
        File.write("foo.txt", "bar")
        File.write("foo.txt", "x", 1)
        assert_equal "bxr", File.read("foo.txt")
      end

      should "accepts a :mode option" do
        File.write("foo.txt", "bar")
        File.write("foo.txt", "x", :mode => 'a')
        assert_equal "barx", File.read("foo.txt")
      end

      should "accepts a :mode option with offset" do
        File.write("foo.txt", "bar")
        File.write("foo.txt", "x", 2, :mode => 'w')
        assert_equal "\0\0x", File.read("foo.txt")
      end

      should "return the number of bytes written" do
        assert_equal 2, File.write('foo.txt', 'hi')
      end

      if defined? Encoding
        should "honor encoding" do
          assert_equal 2, File.write('foo.txt', 'hi', :encoding => "utf-8")
          assert_equal 4, File.write('foo.txt', 'hi', :encoding => "utf-16le")
          assert_equal 8, File.write('foo.txt', 'hi', :encoding => Encoding::UTF_32LE)
        end
      else
        should "ignore encoding if not supported" do
          assert_equal 2, File.write('foo.txt', 'hi', :encoding => "utf-8")
        end
      end
    end

    context "binwrite" do
    end
  end
end
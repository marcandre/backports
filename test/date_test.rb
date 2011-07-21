require 'test_helper'
require 'date'

class DateTest < Test::Unit::TestCase
  context "Date" do
    context "#to_time" do
      should "produce a time object" do
        assert_equal Time, Date.today.to_time.class
      end
    end
  end

  context "DateTime" do
    context "#to_time" do
      should "produce a time object" do
        assert_equal Time, DateTime.now.to_time.class
      end
    end
  end

  context "Time" do
    context "#to_time" do
      should "produce a time object" do
        assert_equal Time, Time.now.to_time.class
      end
    end
  end
end

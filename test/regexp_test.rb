require 'test_helper'

class RegexpTest < Test::Unit::TestCase
  context "Regexp" do
    context ".union" do
      should "conform to doc" do
        assert_equal /cat/            , Regexp.union("cat")
        assert_equal /cat|dog/        , Regexp.union("cat", "dog") 
        assert_equal /cat|dog/        , Regexp.union(%w{ cat dog })
        assert_equal /cat|(?i-mx:dog)/, Regexp.union("cat", /dog/i)
      end
    end
  end
end
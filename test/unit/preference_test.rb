require 'test_helper'

class PreferenceTest < ActiveSupport::TestCase
  test "rating must not be null" do
    test_attribute_may_not_be_null preferences(:one), :rating
  end

  test "rating must be between 0 and 5" do
    #TODO: implement this
  end

end

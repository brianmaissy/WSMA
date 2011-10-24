require 'test_helper'

class UserHourRequirementTest < ActiveSupport::TestCase
  test "week must not be null" do
    test_attribute_may_not_be_null user_hour_requirements(:one), :week
  end

  test "week must be nonnegative" do
    test_attribute_must_be_nonnegative user_hour_requirements(:one), :week
  end

  test "week must be unique given user" do
    #TODO: implement this
  end

  test "hours must not be null" do
    test_attribute_may_not_be_null user_hour_requirements(:one), :hours
  end

  test "hours must be nonnegative" do
    test_attribute_must_be_nonnegative user_hour_requirements(:one), :hours
  end

end

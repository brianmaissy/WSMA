require 'test_helper'

class HouseHourRequirementTest < ActiveSupport::TestCase
  test "week must not be null" do
    test_attribute_may_not_be_null house_hour_requirements(:one), :week
  end

  test "week must be nonnegative" do
    test_attribute_must_be_nonnegative house_hour_requirements(:one), :week
  end

  test "week must be unique given house" do
    #TODO: implement this
  end

  test "hours must not be null" do
    test_attribute_may_not_be_null house_hour_requirements(:one), :hours
  end

  test "hours must be nonnegative" do
    test_attribute_must_be_nonnegative house_hour_requirements(:one), :hours
  end

end

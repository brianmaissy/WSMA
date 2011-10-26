require 'test_helper'

class ChoreTest < ActiveSupport::TestCase
  test "name must not be null" do
    test_attribute_may_not_be_null chores(:one), :name
  end

  test "hours must not be null" do
    test_attribute_may_not_be_null chores(:one), :hours
  end

  test "hours must be nonnegative" do
    test_attribute_must_be_nonnegative chores(:one), :hours
  end
      
  test "sign out by hours before must not be null" do
    test_attribute_may_not_be_null chores(:one), :sign_out_by_hours_before
  end

  test "sign out by hours before must be nonnegative" do
    test_attribute_must_be_nonnegative chores(:one), :sign_out_by_hours_before
  end

  test "due hours after must be greater than hours" do
    #TODO: implement this
  end

end

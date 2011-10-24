require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  test "week must not be null" do
    test_attribute_may_not_be_null assignments(:one), :week
  end

  test "week must be nonnegative" do
    test_attribute_must_be_nonnegative assignments(:one), :week
  end

  test "status must not be null" do
    test_attribute_may_not_be_null assignments(:one), :status
  end

  test "status must be 1,2, or 3" do
    #TODO: implement this
  end

  test "blow_off_job_id must not be null" do
    test_attribute_may_not_be_null assignments(:one), :blow_off_job_id
  end

end

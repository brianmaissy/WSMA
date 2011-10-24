require 'test_helper'

class FiningPeriodTest < ActiveSupport::TestCase
  test "fining_week must not be null" do
    test_attribute_may_not_be_null fining_periods(:one), :fining_week
  end

  test "fining_week must be nonnegative" do
    test_attribute_must_be_nonnegative fining_periods(:one), :fining_week
  end

  test "fine_for_hours_below must not be null" do
    test_attribute_may_not_be_null fining_periods(:one), :fine_for_hours_below
    
  test "fine_for_hours_below must be nonpositive" do
    #TODO: implement this
  end
    
  test "fine_per_hour_below must not be null" do
    test_attribute_may_not_be_null fining_periods(:one), :fine_per_hour_below
  end
    
  test "fine_per_hour_below must be nonnegative" do
    test_attribute_must_be_nonnegative fining_periods(:one), :fine_per_hour_below
  end
    
  test "forgive_percentage_of_fined_hours must not be null" do
    test_attribute_may_not_be_null fining_periods(:one), :forgive_percentage_of_fined_hours
  end
    
  test "forgive_percentage_of_fined_hours must be between 0 and 1" do
    #TODO: implement this
  end
    
  test "fine_job_id must not be null" do
    test_attribute_may_not_be_null fining_periods(:one), :fine_job_id
  end
  
end

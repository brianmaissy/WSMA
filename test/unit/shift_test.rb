require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  test "day_of_week must not be null" do
    test_attribute_may_not_be_null shifts(:one), :day_of_week
  end

  test "day_of_week must be between 1 and 7" do
    #TODO: implement this
  end

  test "time must not be null" do
    test_attribute_may_not_be_null shifts(:one), :time
  end

  test "temporary must not be null" do
    test_attribute_may_not_be_null shifts(:one), :temporary
  end

  test "temporary must be 0 or 1" do
    #TODO: implement this
  end

end

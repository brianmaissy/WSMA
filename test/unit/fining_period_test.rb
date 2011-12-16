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
  end
    
  test "fine_for_hours_below must be nonpositive" do
    test_attribute_must_be_nonpositive fining_periods(:one), :fine_for_hours_below
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
  
  test "initialize_defaults works" do
    h1 = House.create(:name => "testHouse", :hours_per_week => 5, :current_week => 2)
    u1 = User.new(:name => "testUser", :email => "testEmail", :house => h1, :access_level => 3)
    u1.password = "testPassword"
    u1.save!
    h1.blow_off_penalty_factor = 1.2
    fp1 = FiningPeriod.create(:house => h1, :fining_week => 3, :fine_for_hours_below => -1, :forgive_percentage_of_fined_hours => 0.5, :fine_per_hour_below => 10)
    c1 = Chore.create(:house => h1, :name => "a", :hours => 3, :sign_out_by_hours_before => 2, :due_hours_after => 4)
    s1 = Shift.create(:day_of_week => 1, :chore => c1, :time => TimeProvider.now, :temporary => 0)
    a1 = Assignment.create(:user => u1, :shift => s1, :week => 1, :status => 2)
    TimeProvider.set_mock_time h1.end_of_week(3)
    TimeProvider.advance_mock_time(h1.sign_off_by_hours_after.hours.to_f.hours + 1.minute)
    assert_equal(60, u1.fines[0].amount)
  end

  test "calculate_fines correctly creates fines" do
    h1 = House.create(:name => "testHouse", :hours_per_week => 5, :current_week => 2)
    u1 = User.new(:name => "testUser", :email => "testEmail", :house => h1, :access_level => 3)
    u1.password = "testPassword"
    u1.save!
    h1.blow_off_penalty_factor = 1.2
    fp1 = FiningPeriod.create(:house => h1, :fining_week => 3, :fine_for_hours_below => -1, :forgive_percentage_of_fined_hours => 0.5, :fine_per_hour_below => 10)
    c1 = Chore.create(:house => h1, :name => "a", :hours => 3, :sign_out_by_hours_before => 2, :due_hours_after => 4)
    s1 = Shift.create(:day_of_week => 1, :chore => c1, :time => TimeProvider.now, :temporary => 0)
    a1 = Assignment.create(:user => u1, :shift => s1, :week => 1, :status => 2)
    fp1.calculate_fines
    assert_equal(60, u1.fines[0].amount)
  end

  def teardown
    TimeProvider.unschedule_all_tasks
  end

end

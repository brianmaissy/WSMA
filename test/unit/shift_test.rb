require 'test_helper'

class ShiftTest < ActiveSupport::TestCase

  def setup
    @house = House.create(:name => "testHouse", :hours_per_week => 5)
    @user = User.new(:name => "testUser", :email => "testEmail", :house => @house, :access_level => 3)
    @user.password = "testPassword"
    @user.save!
  end

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

  test "temporary shifts cannot be allocated" do
    c1 = Chore.create(:house => @house, :name => "a", :hours => 2, :sign_out_by_hours_before => 2, :due_hours_after => 4)
    s1 = Shift.create(:day_of_week => 1, :chore => c1, :time => TimeProvider.now, :temporary => 1)
    s1.user = @user
    assert s1.invalid?
  end

  test "assignment start time" do
    beginning = @house.beginning_of_this_week TimeProvider.now
    TimeProvider.set_mock_time(beginning)
    c1 = Chore.create(:house => @house, :name => "a", :hours => 2, :sign_out_by_hours_before => 2, :due_hours_after => 4)
    s1 = Shift.create(:day_of_week => '2', :chore => c1, :time => Time.mktime(2000, 1, 1, 14, 30), :temporary => 1)
    start_time = s1.start_time_this_week
    assert_equal(beginning + 2.days + 14.hours + 30.minutes, start_time)
  end

  test "blow off time" do
    beginning = @house.beginning_of_this_week TimeProvider.now
    TimeProvider.set_mock_time(beginning)
    house = House.create(:name => "testHouse1", :hours_per_week => 5, :sign_off_by_hours_after => 7)
    c1 = Chore.create(:house => house, :name => "a", :hours => 2, :sign_out_by_hours_before => 2, :due_hours_after => 4)
    s1 = Shift.create(:day_of_week => '2', :chore => c1, :time => Time.mktime(2000, 1, 1, 14, 30), :temporary => 1)
    blow_off_time = s1.blow_off_time
    assert_equal(beginning + 2.days + 14.hours + 30.minutes + 2.hours + 4.hours + 7.hours, blow_off_time)
  end

end

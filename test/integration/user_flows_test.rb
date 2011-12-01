require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "one sample week" do
    @house = House.create(:name => "testHouse", :hours_per_week => 5, :sign_off_verification_mode => 0)
    @house.current_week = 1
    @house.save!
    @user1 = User.new(:name => "testUser1", :email => "testEmail1", :house => @house, :access_level => 3)
    @user1.password = "testPassword1"
    @user1.save!
    @user2 = User.new(:name => "testUser2", :email => "testEmail2", :house => @house, :access_level => 3)
    @user2.password = "testPassword2"
    @user2.save!
    @chore = Chore.create(:house => @house, :name => "wash dishes", :hours => 3, :sign_out_by_hours_before => 2, :due_hours_after => 3)
    @shift1 = Shift.create(:day_of_week => 1, :chore => @chore, :time => Time.mktime(2000, 1, 1, 14, 30), :temporary => 0)
    @shift2 = Shift.create(:day_of_week => 3, :chore => @chore, :time => Time.mktime(2000, 1, 8, 14, 30), :temporary => 0)
    @assignment1 = Assignment.create(:user => @user1, :shift => @shift1, :week => 1, :status => 1)
    @assignment2 = Assignment.create(:user => @user2, :shift => @shift1, :week => 1, :status => 1)
    TimeProvider.set_mock_time(@shift1.start_time_this_week)
    TimeProvider.advance_mock_time 3.hours
    assert_equal(1, @assignment1.status)
    @assignment1.sign_off
    assert_equal(@assignment1.user, @user1)
    assert_equal(2, @assignment1.status)
    assert_equal(3, @assignment1.chore.hours)
    assert_equal(3, @user1.completed_hours_this_week)
    TimeProvider.set_mock_time(@shift2.start_time_this_week)
    TimeProvider.advance_mock_time -2.hours
    @assignment2.sign_out
    assert_equal(0, @user2.completed_hours_this_week)
  end

end

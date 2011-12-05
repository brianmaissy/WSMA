require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase

  def setup
    @assignments = []
  end

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
    assignment = Assignment.create(:user => users(:one), :shift => shifts(:one), :week => 11, :status => 1)
    assert assignment.valid?
    for number in MANY_NONINTEGERS
      assignment.status = number
      assert assignment.invalid?
      assert assignment.errors[:status].include? "must be an integer"
    end
    for number in [-1,4,5]
      assignment.status = number
      assert assignment.invalid?
      assert assignment.errors[:status].include? "must be 1, 2, or 3"
    end
    for number in [1,2,3]
      assignment.status = number
      assert assignment.valid?
    end
  end

  test "cannot assign the same chore twice in a week" do
    assignment = Assignment.create(:user => users(:one), :shift => shifts(:one), :week => 11, :status => 1)
    @assignments << assignment
    assignment = Assignment.new(:user => users(:one), :shift => shifts(:one), :week => 11, :status => 1)
    @assignments << assignment
    assert assignment.invalid?
    assignment = Assignment.new(:user => users(:two), :shift => shifts(:one), :week => 11, :status => 1)
    @assignments << assignment
    assert assignment.invalid?
    assignment = Assignment.new(:user => users(:one), :shift => shifts(:one), :week => 12, :status => 1)
    @assignments << assignment
    assert assignment.valid?
  end

  test "sign_off changes status of assignment from pending to completed" do
    assignment = Assignment.new(:user => users(:one), :shift => shifts(:one), :week => 11, :status => 1)
    @assignments << assignment
    assignment.sign_off
    assert_equal(2, assignment.status)
  end

  test "sign_out removes respective assignment" do
    count = ScheduledJob.count
    assignment = Assignment.new(:user => users(:one), :shift => shifts(:one), :week => 11, :status => 1)
    @assignments << assignment
    assignment.save!
    assert_equal(count + 1, ScheduledJob.count)
    assignment.sign_out
    assert_raises ActiveRecord::RecordNotFound do
      Assignment.find(assignment)
    end
    assert_equal(count, ScheduledJob.count)
  end
  
  test "sign_off(user,password) removes respective assignment" do
    assignment = Assignment.new(:user => users(:one), :shift => shifts(:one), :week => 11, :status => 1)
    @assignments << assignment
    assignment.house.using_online_sign_off = 1 
    assignment.house.sign_off_verification_mode = 2
    @house = House.create(:name => "testHouse", :hours_per_week => 5)
    @user = User.new(:name => "testUser", :email => "testEmail", :house => @house, :access_level => 3)
    @user.password = "testPassword"
    @user.save!
    assignment.sign_off(@user, @user.password)
    assert_equal(2, assignment.status)
  end

  test "blow off works" do
    #TODO: write this test
    # make new assignment, go to shift ending time, check assignment is blown off
    assignment = Assignment.new(:user => users(:one), :shift => shifts(:one), :week => 11, :status => 1)
    assignment.house.using_online_sign_off = 1
    assignment.house.save!
    assignment.save!
    TimeProvider.set_mock_time(assignment.shift.blow_off_time)
    assert_equal(3, assignment.status)
  end

  def teardown
    for assignment in @assignments
      assignment.destroy
    end
  end

end
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @house = House.create(:name => "testHouse", :hours_per_week => 5)
    @user = User.new(:name => "testUser", :email => "testEmail", :house => @house, :access_level => 3)
    @user.password = "testPassword"
    @user.save!
  end

  test "set_defaults_works" do
    assert_equal @house.hours_per_week, @user.hours_per_week
  end
  
  test "house_id must not be null" do
    test_attribute_may_not_be_null @user, :house_id
  end
  
  test "name must not be null" do
    test_attribute_may_not_be_null @user, :name
  end
  
  test "email must not be null" do
    test_attribute_may_not_be_null @user, :email
  end
  
  test "email must be unique" do
    @user = User.new(@user.attributes)
    test_attribute_must_be_unique @user, :email
  end
  
  test "password must not be blank" do
    assert @user.valid?
    @user.password = ""
    assert @user.invalid?
  end
  
  test "access level must not be null" do
    test_attribute_may_not_be_null @user, :access_level
  end
  
  test "access level must be 1, 2, or 3" do
    assert @user.valid?
    for number in MANY_NONINTEGERS
      @user.access_level = number
      assert @user.invalid?
      assert @user.errors[:access_level].include? "must be an integer"
    end
    for number in [-1,0,4,5]
      @user.access_level = number
      assert @user.invalid?
      assert @user.errors[:access_level].include? "must be 1, 2, or 3"
    end
    for number in [1, 2, 3]
      @user.access_level = number
      assert @user.valid?
    end
  end

  test "hours per week must not be null" do
     test_attribute_may_not_be_null @user, :hours_per_week
  end
  
  test "hours per week must be nonnegative" do
    test_attribute_must_be_nonnegative @user, :hours_per_week
  end

  test "hours_required_for_week works" do
    assert_equal(5, @user.hours_required_for_week(0))
    @user.hours_per_week = 4
    assert_equal(4, @user.hours_required_for_week(0))
    UserHourRequirement.create(:user => @user, :week => 0, :hours => 3)
    assert_equal(3, @user.hours_required_for_week(0))
    HouseHourRequirement.create(:house => @house, :week => 0, :hours => 2)
    assert_equal(2, @user.hours_required_for_week(0))
  end

  test "hour balance calculation" do
    @house.blow_off_penalty_factor = 1.2
    Assignment.create(:user => @user, :shift => shifts(:one), :week => 2, :status => 2)
    Assignment.create(:user => @user, :shift => shifts(:one), :week => 4, :status => 2)
    Assignment.create(:user => @user, :shift => shifts(:one), :week => 5, :status => 2)
    Assignment.create(:user => @user, :shift => shifts(:one), :week => 6, :status => 1)
    assert_equal(shifts(:one).chore.hours * 3, @user.hour_balance)
    @house.current_week = 2
    assert_equal(shifts(:one).chore.hours * 3 - 2*@house.hours_per_week, @user.hour_balance)
    Assignment.create(:user => @user, :shift => shifts(:one), :week => 3, :status => 3)
    assert_equal(shifts(:one).chore.hours * (3 - 1.2) - 2*@house.hours_per_week, @user.hour_balance)
    fp = FiningPeriod.new(:house => @house, :fining_week => 1, :fine_for_hours_below => -1, :fine_per_hour_below => 1, :forgive_percentage_of_fined_hours => 0.4)
    f1 = Fine.create(:user => @user, :fining_period => fp, :paid => 0, :amount => 42, :hours_fined_for => 3)
    f2 = Fine.create(:user => @user, :paid => 0, :amount => 42, :hours_fined_for => 7)
    assert_float_equal(shifts(:one).chore.hours * (3 - 1.2) - 2*@house.hours_per_week + 0.4*3, @user.hour_balance, 0.01)
  end

  test "total allocated hours calculation" do
    assert_equal(0, @user.total_allocated_hours)
    s1 = Shift.create(:user => @user, :day_of_week => 1, :chore => chores(:one), :time => TimeProvider.now, :temporary => 0)
    assert s1.valid?
    assert_equal(chores(:one).hours, @user.total_allocated_hours)
    s2 = Shift.create(:user => @user, :day_of_week => 1, :chore => chores(:two), :time => TimeProvider.now, :temporary => 0)
    assert s2.valid?
    assert_equal(chores(:one).hours + chores(:two).hours, @user.total_allocated_hours)
  end

  test "assigned hours this week calculation" do
    Assignment.create(:user => @user, :shift => shifts(:one), :week => 0, :status => 1)
    Assignment.create(:user => @user, :shift => shifts(:two), :week => 0, :status => 2)
    Assignment.create(:user => @user, :shift => shifts(:one), :week => 1, :status => 2)
    assert_equal(shifts(:one).chore.hours + shifts(:two).chore.hours, @user.assigned_hours_this_week)
  end

  test "pending hours this week calculation" do
    Assignment.create(:user => @user, :shift => shifts(:one), :week => 0, :status => 1)
    Assignment.create(:user => @user, :shift => shifts(:two), :week => 0, :status => 2)
    Assignment.create(:user => @user, :shift => shifts(:one), :week => 1, :status => 2)
    assert_equal(shifts(:one).chore.hours, @user.pending_hours_this_week)
  end

  test "completed hours this week calculation" do
    Assignment.create(:user => @user, :shift => shifts(:one), :week => 0, :status => 1)
    Assignment.create(:user => @user, :shift => shifts(:two), :week => 0, :status => 2)
    Assignment.create(:user => @user, :shift => shifts(:one), :week => 1, :status => 2)
    assert_equal(shifts(:two).chore.hours, @user.completed_hours_this_week)
  end

end

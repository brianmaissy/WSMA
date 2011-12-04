require 'test_helper'

class HouseTest < ActiveSupport::TestCase

  def setup
    @house = House.create(:name => "testHouse", :hours_per_week => 5)
    @user = User.new(:name => "testUser", :email => "testEmail", :house => @house, :access_level => 3)
    @user.password = "testPassword"
    @user.save!
  end

  test "set defaults works" do
    @house = House.create(:name => "defaultHouse")
    assert @house.hours_per_week == 0
    assert @house.sign_off_by_hours_after == 0
    assert @house.blow_off_penalty_factor == 0
    assert @house.using_online_sign_off == 1
    assert @house.sign_off_verification_mode == 2
  end
  
  test "name must not be null" do
    test_attribute_may_not_be_null @house, :name
  end
  
  test "name must be unique" do
    @house = House.new(@house.attributes)
    test_attribute_must_be_unique @house, :name
  end

  test "current_week must not be null" do
    test_attribute_may_not_be_null @house, :current_week
  end

  test "permanent chores start week must be null or positive integer" do
    test_attribute_must_be_null_or_positive_integer @house, :permanent_chores_start_week
  end
  
  test "hours per week must not be null" do
     test_attribute_may_not_be_null @house, :hours_per_week
  end
  
  test "hours per week must be nonnegative" do
    test_attribute_must_be_nonnegative @house, :hours_per_week
  end
  
  test "sign off by hours after must not be null" do
     test_attribute_may_not_be_null @house, :sign_off_by_hours_after
  end
  
  test "sign off by hours after must be nonnegative" do
    test_attribute_must_be_nonnegative @house, :sign_off_by_hours_after
  end
  
  test "using online sign off must not be null" do
    test_attribute_may_not_be_null @house, :using_online_sign_off
  end

  test "using online sign off must be 0 or 1" do
    assert @house.valid?
    for number in MANY_NONINTEGERS
      @house.using_online_sign_off = number
      assert @house.invalid?
      assert @house.errors[:using_online_sign_off].include? "must be an integer"
    end
    for number in [-1,2,3]
      @house.using_online_sign_off = number
      assert @house.invalid?
      assert @house.errors[:using_online_sign_off].include? "must be 0 or 1"
    end
    for number in [0,1]
      @house.using_online_sign_off = number
      assert @house.valid?
    end
  end

  test "sign off verification mode must not be null" do
    test_attribute_may_not_be_null @house, :sign_off_verification_mode
  end

  test "sign off verification mode must be 0, 1, or 2" do
    assert @house.valid?
    for number in MANY_NONINTEGERS
      @house.sign_off_verification_mode = number
      assert @house.invalid?
      assert @house.errors[:sign_off_verification_mode].include? "must be an integer"
    end
    for number in [-1,3,4]
      @house.sign_off_verification_mode = number
      assert @house.invalid?
      assert @house.errors[:sign_off_verification_mode].include? "must be 0, 1, or 2"
    end
    for number in [0,1,2]
      @house.sign_off_verification_mode = number
      assert @house.valid?
    end
  end
  
  test "blow off penalty factor must not be null" do
    test_attribute_may_not_be_null @house, :blow_off_penalty_factor
  end
  
  test "blow off penalty factor must be nonnegative" do
    test_attribute_must_be_nonnegative @house, :blow_off_penalty_factor
  end

  test "unassigned shifts works" do
    c1 = Chore.create(:house => @house, :name => "a", :hours => 2, :sign_out_by_hours_before => 2, :due_hours_after => 4)
    c2 = Chore.create(:house => @house, :name => "b", :hours => 2, :sign_out_by_hours_before => 2, :due_hours_after => 4)
    assert_equal(0, @house.unassigned_shifts.length)
    s1 = Shift.create(:day_of_week => 1, :chore => c1, :time => TimeProvider.now, :temporary => 0)
    assert_equal(1, @house.unassigned_shifts.length)
    assert_equal(s1, @house.unassigned_shifts[0])
    s2 = Shift.create(:user => users(:one), :day_of_week => 1, :chore => c2, :time => TimeProvider.now, :temporary => 0)
    assert_equal(2, @house.unassigned_shifts.length)
    @assignment = Assignment.create(:user => users(:one), :shift => s1, :week => 0, :status => 1)
    assert_equal(1, @house.unassigned_shifts.length)
    assert_equal(s2, @house.unassigned_shifts[0])
  end

  test "unallocated shifts works" do
    c1 = Chore.create(:house => @house, :name => "a", :hours => 2, :sign_out_by_hours_before => 2, :due_hours_after => 4)
    c2 = Chore.create(:house => @house, :name => "b", :hours => 2, :sign_out_by_hours_before => 2, :due_hours_after => 4)
    assert_equal(0, @house.unallocated_shifts.length)
    s1 = Shift.create(:day_of_week => 1, :chore => c1, :time => TimeProvider.now, :temporary => 0)
    # temporary shift should be ignored
    s2 = Shift.create(:day_of_week => 2, :chore => c1, :time => TimeProvider.now, :temporary => 1)
    Shift.create(:user => users(:one), :day_of_week => 1, :chore => c2, :time => TimeProvider.now, :temporary => 0)
    assert_equal(1, @house.unallocated_shifts.length)
    assert_equal(s1, @house.unallocated_shifts[0])
  end

  test "beginning of this week" do
    beginning = @house.beginning_of_this_week TimeProvider.now
    assert_equal(0, beginning.wday)
    assert_equal(0, beginning.hour)
    assert_equal(0, beginning.min)
    assert(beginning < TimeProvider.now)
    assert_equal(beginning, @house.beginning_of_this_week(beginning))
  end

  test "next sunday at midnight" do
    TimeProvider.set_mock_time
    next_sunday = @house.next_sunday_at_midnight TimeProvider.now
    assert_equal(0, next_sunday.wday)
    assert_equal(0, next_sunday.hour)
    assert_equal(0, next_sunday.min)
    assert(next_sunday > TimeProvider.now)
    beginning = @house.beginning_of_this_week TimeProvider.now
    assert_equal(next_sunday, beginning + 7.days)
  end

  test "cannot decrease current week" do
    @house.current_week = 2
    assert_raise ArgumentError do
      @house.current_week = 1
    end
  end

  test "cannot set permanent chores start week to week that has passed" do
    @house.current_week = 3
    assert_raise ArgumentError do
      @house.permanent_chores_start_week = 2
    end
    assert_raise ArgumentError do
      @house.permanent_chores_start_week = 3
    end
  end

  test "cannot set semester start date to date that has passed, or when old start date has passed" do
    assert_raise ArgumentError do
      @house.semester_start_date = TimeProvider.now - 2.weeks
    end
    @house.semester_start_date = TimeProvider.now + 1.minute
    TimeProvider.advance_mock_time 2.weeks
    assert_raise ArgumentError do
      @house.semester_start_date = TimeProvider.now + 2.weeks
    end
  end

  test "changing semester start date changes scheduled task" do
    @house.semester_end_date = TimeProvider.now + 1.month
    @house.semester_start_date = TimeProvider.now + 1.minute
    @house.semester_start_date = TimeProvider.now + 1.week
    week = @house.current_week
    @house.save
    TimeProvider.set_mock_time @house.next_sunday_at_midnight TimeProvider.now + 1.minute
    TimeProvider.advance_mock_time 1.minute
    assert_equal(week, @house.current_week)
    TimeProvider.advance_mock_time 1.week
    TimeProvider.advance_mock_time 1.minute
    @house.reload
    assert_equal(week+1, @house.current_week)
  end

  test "cannot set semester end date to date that has passed, or when old end date has passed" do
    assert_raise ArgumentError do
      @house.semester_end_date = TimeProvider.now - 2.weeks
    end
    @house.semester_end_date = TimeProvider.now + 1.minute
    TimeProvider.advance_mock_time 2.weeks
    assert_raise ArgumentError do
      @house.semester_end_date = TimeProvider.now + 2.weeks
    end
  end

  test "cancel jobs" do
    @house.schedule_new_week_job TimeProvider.now + 1.hour
    count = TimeProvider.task_count
    @house.destroy
    assert_equal(count-1, TimeProvider.task_count)
  end

  test "start new week increments current_week" do
    @house.current_week= 3
    TimeProvider.set_mock_time
    @house.semester_end_date = TimeProvider.now + 1.minute
    @house.start_new_week
    assert_equal(4, @house.current_week)
  end

  test "start new week assigns chores without online sign off" do
    c1 = Chore.create(:house => @house, :name => "a", :hours => 2, :sign_out_by_hours_before => 2, :due_hours_after => 4)
    s1 = Shift.create(:user => @user, :day_of_week => 1, :chore => c1, :time => TimeProvider.now, :temporary => 0)
    @house.using_online_sign_off = 0
    @house.current_week = 1
    @house.permanent_chores_start_week = 2
    @house.save
    assert_equal(0, @user.assigned_hours_this_week)
    @house.start_new_week
    assert_equal(c1.hours, @user.assigned_hours_this_week)
    assert_equal(c1.hours, @user.completed_hours_this_week)
    assert_equal(0, @user.pending_hours_this_week)
  end

  test "start new week assigns chores using online sign off" do
    c1 = Chore.create(:house => @house, :name => "a", :hours => 2, :sign_out_by_hours_before => 2, :due_hours_after => 4)
    s1 = Shift.create(:user => @user, :day_of_week => 1, :chore => c1, :time => TimeProvider.now, :temporary => 0)
    @house.using_online_sign_off = 1
    @house.current_week = 1
    @house.permanent_chores_start_week = 2
    @house.semester_end_date = TimeProvider.now + 1.month
    @house.save
    assert_equal(0, @user.assigned_hours_this_week)
    @house.start_new_week
    assert_equal(c1.hours, @user.assigned_hours_this_week)
    assert_equal(c1.hours, @user.pending_hours_this_week)
    assert_equal(0, @user.completed_hours_this_week)
  end

  test "next Sunday at midnight works properly" do
    TimeProvider.set_mock_time
    sunday = @house.next_sunday_at_midnight TimeProvider.now
    assert_equal(0, sunday.wday)
    assert_equal(0, sunday.hour)
    monday_afternoon = sunday + 30.hours + 12.minutes + 3.seconds
    assert_equal(1, monday_afternoon.wday)
    assert_equal(6, monday_afternoon.hour)
    assert_equal(sunday + 7.days, @house.next_sunday_at_midnight(sunday))
  end

  test "end of week" do
    TimeProvider.set_mock_time
    @house.current_week = 3
    assert_equal(@house.next_sunday_at_midnight(TimeProvider.now), @house.end_of_this_week(TimeProvider.now))
    assert_equal(@house.end_of_this_week(TimeProvider.now).advance(:days => 14), @house.end_of_week(5))
  end

  test "job scheduling works" do
    c1 = Chore.create(:house => @house, :name => "a", :hours => 2, :sign_out_by_hours_before => 2, :due_hours_after => 4)
    s1 = Shift.create(:user => @user, :day_of_week => 1, :chore => c1, :time => TimeProvider.now, :temporary => 0)
    @house.using_online_sign_off = 1
    @house.current_week = 1
    @house.permanent_chores_start_week = 2
    @house.semester_end_date = TimeProvider.now + 1.month
    @house.save
    assert_equal(0, @user.assigned_hours_this_week)
    count = ScheduledJob.find_all_by_target_class("House").count
    @house.schedule_new_week_job @house.next_sunday_at_midnight(TimeProvider.now)
    assert_equal(count+1, ScheduledJob.find_all_by_target_class("House").count)
    TimeProvider.advance_mock_time(7.days)
    assert_equal(count+1, ScheduledJob.find_all_by_target_class("House").count)
    @user.reload
    assert_equal(c1.hours, @user.assigned_hours_this_week)
    assert_equal(c1.hours, @user.pending_hours_this_week)
    assert_equal(0, @user.completed_hours_this_week)
  end

  test "jobs persist beyond TimeProvider lifetime" do
    c1 = Chore.create(:house => @house, :name => "a", :hours => 2, :sign_out_by_hours_before => 2, :due_hours_after => 4)
    s1 = Shift.create(:user => @user, :day_of_week => 1, :chore => c1, :time => TimeProvider.now, :temporary => 0)
    @house.using_online_sign_off = 1
    @house.current_week = 1
    @house.permanent_chores_start_week = 2
    @house.semester_end_date = TimeProvider.now + 1.month
    @house.save
    assert_equal(0, @user.assigned_hours_this_week)
    count = ScheduledJob.find_all_by_target_class("House").count
    @house.schedule_new_week_job @house.next_sunday_at_midnight(TimeProvider.now)
    assert_equal(count+1, ScheduledJob.find_all_by_target_class("House").count)
    TimeProvider.reload_jobs
    assert_equal(count+1, ScheduledJob.find_all_by_target_class("House").count)
    TimeProvider.advance_mock_time(7.days)
    assert_equal(count+1, ScheduledJob.find_all_by_target_class("House").count)
    @user.reload
    assert_equal(c1.hours, @user.assigned_hours_this_week)
    assert_equal(c1.hours, @user.pending_hours_this_week)
    assert_equal(0, @user.completed_hours_this_week)
  end

  def teardown
    @house.destroy if !@house.nil?
    @assignment.destroy if !@assignment.nil?
  end

end

require 'test_helper'

class HouseTest < ActiveSupport::TestCase

  def setup
    @house = House.create(:name => "testHouse", :hours_per_week => 5)
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

  test "permanent chores start week must be null or nonnegative integer" do
    test_attribute_must_be_null_or_nonnegative_integer @house, :permanent_chores_start_week
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
    s1 = Shift.create(:day_of_week => 1, :chore => c1, :time => Time.now, :temporary => 0)
    assert_equal(1, @house.unassigned_shifts.length)
    assert_equal(s1, @house.unassigned_shifts[0])
    s2 = Shift.create(:user => users(:one), :day_of_week => 1, :chore => c2, :time => Time.now, :temporary => 0)
    assert_equal(2, @house.unassigned_shifts.length)
    Assignment.create(:user => users(:one), :shift => s1, :week => 0, :status => 1, :blow_off_job_id => "a")
    assert_equal(1, @house.unassigned_shifts.length)
    assert_equal(s2, @house.unassigned_shifts[0])
  end

  test "unallocated shifts works" do
    c1 = Chore.create(:house => @house, :name => "a", :hours => 2, :sign_out_by_hours_before => 2, :due_hours_after => 4)
    c2 = Chore.create(:house => @house, :name => "b", :hours => 2, :sign_out_by_hours_before => 2, :due_hours_after => 4)
    assert_equal(0, @house.unallocated_shifts.length)
    s1 = Shift.create(:day_of_week => 1, :chore => c1, :time => Time.now, :temporary => 0)
    Shift.create(:user => users(:one), :day_of_week => 1, :chore => c2, :time => Time.now, :temporary => 0)
    assert_equal(1, @house.unallocated_shifts.length)
    assert_equal(s1, @house.unallocated_shifts[0])
  end

end

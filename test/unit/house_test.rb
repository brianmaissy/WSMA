require 'test_helper'

class HouseTest < ActiveSupport::TestCase
  test "set defaults works" do
    house = House.new
    assert house.hours_per_week == 0
    assert house.sign_off_by_hours_after == 0
    assert house.blow_off_penalty_factor == 0
    assert house.using_online_sign_off == 1
    assert house.sign_off_verification_mode == 2
  end
  
  test "name must not be null" do
    test_attribute_may_not_be_null houses(:one), :name
  end
  
  test "name must be unique" do
    test_attribute_must_be_unique House.new(houses(:one).attributes), :name
  end
  
  test "permanent chores start week must be null or nonnegative integer" do
    test_attribute_must_be_null_or_nonnegative_integer houses(:one), :permanent_chores_start_week
  end
  
  test "hours per week must not be null" do
     test_attribute_may_not_be_null houses(:one), :hours_per_week
  end
  
  test "hours per week must be nonnegative" do
    test_attribute_must_be_nonnegative houses(:one), :hours_per_week
  end
  
  test "sign off by hours after must not be null" do
     test_attribute_may_not_be_null houses(:one), :sign_off_by_hours_after
  end
  
  test "sign off by hours after must be nonnegative" do
    test_attribute_must_be_nonnegative houses(:one), :sign_off_by_hours_after
  end
  
  test "using online sign off must not be null" do
    test_attribute_may_not_be_null houses(:one), :using_online_sign_off
  end

  test "using online sign off must be 0 or 1" do
    house = houses(:one)
    assert house.valid?
    for number in MANY_NONINTEGERS
      house.using_online_sign_off = number
      assert house.invalid?
      assert house.errors[:using_online_sign_off].include? "must be an integer"
    end
    for number in [-1,2,3]
      house.using_online_sign_off = number
      assert house.invalid?
      assert house.errors[:using_online_sign_off].include? "must be 0 or 1"
    end
    for number in [0,1]
      house.using_online_sign_off = number
      assert house.valid?
    end
  end

  test "sign off verification mode must not be null" do
    test_attribute_may_not_be_null houses(:one), :sign_off_verification_mode
  end

  test "sign off verification mode must be 0, 1, or 2" do
    house = houses(:one)
    assert house.valid?
    for number in MANY_NONINTEGERS
      house.sign_off_verification_mode = number
      assert house.invalid?
      assert house.errors[:sign_off_verification_mode].include? "must be an integer"
    end
    for number in [-1,3,4]
      house.sign_off_verification_mode = number
      assert house.invalid?
      assert house.errors[:sign_off_verification_mode].include? "must be 0, 1, or 2"
    end
    for number in [0,1,2]
      house.sign_off_verification_mode = number
      assert house.valid?
    end
  end
  
  test "blow off penalty factor must not be null" do
    test_attribute_may_not_be_null houses(:one), :blow_off_penalty_factor
  end
  
  test "blow off penalty factor must be nonnegative" do
    test_attribute_must_be_nonnegative houses(:one), :blow_off_penalty_factor
  end

end

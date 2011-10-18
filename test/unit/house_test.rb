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
    house = houses(:one)
    assert house.valid?
    house.name = nil
    assert house.invalid?
  end
  
  test "name must be unique" do
    house = House.new(houses(:one).attributes)
    assert house.invalid?
    house.name = "unique"
    assert house.valid?
  end
  
  test "permanent chores start week must be null or nonnegative integer" do
    house = houses(:one)
    assert house.valid?
    house.permanent_chores_start_week = nil
    assert house.valid?
    for number in many_non_integers
      house.permanent_chores_start_week = number
      assert house.invalid?
      assert house.errors[:permanent_chores_start_week].include? "must be an integer"
    end
    for number in many_negative_integers
      house.permanent_chores_start_week = number
      assert house.invalid?
      assert house.errors[:permanent_chores_start_week].include? "must be greater than or equal to 0"
    end
    for number in many_nonnegative_integers
      house.permanent_chores_start_week = number
      assert house.valid?
    end
  end
  
  test "hours per week must not be null" do
    house = houses(:one)
    assert house.valid?
    house.hours_per_week = nil
    assert house.invalid?
  end
  
  test "hours per week must be nonnegative" do
    house = houses(:one)
    assert house.valid?
    for number in many_negative_integers
      house.hours_per_week = number
      assert house.invalid?
      assert house.errors[:hours_per_week].include? "must be greater than or equal to 0"
    end
    for number in many_nonnegative_integers
      house.hours_per_week = number
      assert house.valid?
    end
  end
  
  test "sign off by hours after must not be null" do
    house = houses(:one)
    assert house.valid?
    house.sign_off_by_hours_after = nil
    assert house.invalid?
  end
  
  test "sign off by hours after must be nonnegative" do
    house = houses(:one)
    assert house.valid?
    for number in many_negative_integers
      house.sign_off_by_hours_after = number
      assert house.invalid?
      assert house.errors[:sign_off_by_hours_after].include? "must be greater than or equal to 0"
    end
    for number in many_nonnegative_integers
      house.sign_off_by_hours_after = number
      assert house.valid?
    end
  end
  
  test "using online sign off must not be null" do
    house = houses(:one)
    assert house.valid?
    house.using_online_sign_off = nil
    assert house.invalid?
  end

  test "using online sign off must be 0 or 1" do
    house = houses(:one)
    assert house.valid?
    for number in many_non_integers
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
    house = houses(:one)
    assert house.valid?
    house.sign_off_verification_mode = nil
    assert house.invalid?
  end

  test "sign off verification mode must be 0, 1, or 2" do
    house = houses(:one)
    assert house.valid?
    for number in many_non_integers
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
    house = houses(:one)
    assert house.valid?
    house.blow_off_penalty_factor = nil
    assert house.invalid?
  end
  
  test "blow off penalty factor must be nonnegative" do
    house = houses(:one)
    assert house.valid?
    for number in many_negative_integers
      house.blow_off_penalty_factor = number
      assert house.invalid?
      assert house.errors[:blow_off_penalty_factor].include? "must be greater than or equal to 0"
    end
    for number in many_nonnegative_integers
      house.blow_off_penalty_factor = number
      assert house.valid?
    end
  end

end

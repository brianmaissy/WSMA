require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "set_defaults_works" do
    @user = User.new(:house => houses(:one))
    assert_equal houses(:one).hours_per_week, @user.hours_per_week
  end
  
  test "house_id must not be null" do
    test_attribute_may_not_be_null users(:one), :house_id
  end
  
  test "name must not be null" do
    test_attribute_may_not_be_null users(:one), :name
  end
  
  test "email must not be null" do
    test_attribute_may_not_be_null users(:one), :email
  end
  
  test "email must be unique" do
    test_attribute_must_be_unique User.new(users(:one).attributes), :email
  end
  
  test "password hash must not be null" do
    test_attribute_may_not_be_null users(:one), :password_hash
  end
  
  test "access level must not be null" do
    test_attribute_may_not_be_null users(:one), :access_level
  end
  
  test "access level must be 1, 2, or 3" do
    user = users(:one)
    assert user.valid?
    for number in MANY_NONINTEGERS
      user.access_level = number
      assert user.invalid?
      assert user.errors[:access_level].include? "must be an integer"
    end
    for number in [-1,0,4,5]
      user.access_level = number
      assert user.invalid?
      assert user.errors[:access_level].include? "must be 1, 2, or 3"
    end
    for number in [1, 2, 3]
      user.access_level = number
      assert user.valid?
    end
  end

  test "hours per week must not be null" do
     test_attribute_may_not_be_null users(:one), :hours_per_week
  end
  
  test "hours per week must be nonnegative" do
    test_attribute_must_be_nonnegative users(:one), :hours_per_week
  end

  test "hours_required_for_week works" do
    house = House.create(:name => "testHouse", :hours_per_week => 5)
    user = User.new(:name => "testUser", :email => "testEmail", :house => house, :access_level => 3)
    user.password = "testPassword"
    user.save!
    assert_equal(5, user.hours_required_for_week(0))
    user.hours_per_week = 4
    assert_equal(4, user.hours_required_for_week(0))
    UserHourRequirement.create(:user => user, :week => 0, :hours => 3)
    assert_equal(3, user.hours_required_for_week(0))
    HouseHourRequirement.create(:house => house, :week => 0, :hours => 2)
    assert_equal(2, user.hours_required_for_week(0))
  end

end

require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
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
    #TODO: implement this
  end

  test "blow_off_job_id must not be null if using online sign off" do
    test_attribute_may_not_be_null assignments(:one), :blow_off_job_id
  end

  test "blow_off_job_id may be null if not using online sign off" do
    house = House.create(:name => "testHouse", :using_online_sign_off => 0)
    c1 = Chore.create(:house => house, :name => "a", :hours => 2, :sign_out_by_hours_before => 2, :due_hours_after => 4)
    s1 = Shift.create(:day_of_week => 1, :chore => c1, :time => TimeProvider.now, :temporary => 0)
    a1 = Assignment.new(:user => users(:one), :shift => s1, :week => 11, :status => 1)
    assert a1.valid?
  end

  test "cannot assign the same chore twice in a week" do
    Assignment.create(:user => users(:one), :shift => shifts(:one), :week => 11, :status => 1, :blow_off_job_id => "a")
    assignment = Assignment.new(:user => users(:one), :shift => shifts(:one), :week => 11, :status => 1, :blow_off_job_id => "a")
    assert assignment.invalid?
    assignment = Assignment.new(:user => users(:two), :shift => shifts(:one), :week => 11, :status => 1, :blow_off_job_id => "a")
    assert assignment.invalid?
    assignment = Assignment.new(:user => users(:one), :shift => shifts(:one), :week => 12, :status => 1, :blow_off_job_id => "a")
    assert assignment.valid?
  end

  test "sign_off changes status of assignment from pending to completed" do
    assignment = Assignment.new(:user => users(:one), :shift => shifts(:one), :week => 11, :status => 1, :blow_off_job_id => "a")
    assignment.sign_off
    assert_equal(2, assignment.status)
  end

  test "sign_out removes respective assignment" do
    assignment = Assignment.new(:user => users(:one), :shift => shifts(:one), :week => 11, :status => 1, :blow_off_job_id => "a")
    assignment.sign_out
    assert_nil(assignment)
  end

end

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

  test "cannot assign the same chore twice in a week" do
    Assignment.create(:user => users(:one), :shift => shifts(:one), :week => 11, :status => 1)
    assignment = Assignment.new(:user => users(:one), :shift => shifts(:one), :week => 11, :status => 1)
    assert assignment.invalid?
    assignment = Assignment.new(:user => users(:two), :shift => shifts(:one), :week => 11, :status => 1)
    assert assignment.invalid?
    assignment = Assignment.new(:user => users(:one), :shift => shifts(:one), :week => 12, :status => 1)
    assert assignment.valid?
  end

  test "sign_off changes status of assignment from pending to completed" do
    assignment = Assignment.new(:user => users(:one), :shift => shifts(:one), :week => 11, :status => 1)
    assignment.sign_off
    assert_equal(2, assignment.status)
  end

  test "sign_out removes respective assignment" do
    assignment = Assignment.new(:user => users(:one), :shift => shifts(:one), :week => 11, :status => 1, :blow_off_job_id => "a")
    assignment.save!
    assignment.sign_out
    assert_nil(assignment)
    
  test "blow off works" do
    #TODO: write this test
  end

end

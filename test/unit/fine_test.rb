require 'test_helper'

class FineTest < ActiveSupport::TestCase
  test "amount must not be null" do
    test_attribute_may_not_be_null fines(:one), :amount
  end

  test "amount must be greater than zero" do
    #TODO: implement this
  end

  test "paid must not be null" do
    test_attribute_may_not_be_null fines(:one), :paid
  end

  test "paid must be 0 or 1" do
    assert fines(:one).valid?
    for number in MANY_NONINTEGERS
      fines(:one).paid = number
      assert fines(:one).invalid?
      assert fines(:one).errors[:paid].include? "must be an integer"
    end
    for number in [-1,2,3]
      fines(:one).paid = number
      assert fines(:one).invalid?
      assert fines(:one).errors[:paid].include? "must be 0 or 1"
    end
    for number in [0,1]
      fines(:one).paid = number
      assert fines(:one).valid?
    end
  end

  test "paid_date must not be null if paid is 1" do
    #TODO: implement this
  end

  test "hours_fined_for must not be null" do
    test_attribute_may_not_be_null fines(:one), :hours_fined_for
  end

end

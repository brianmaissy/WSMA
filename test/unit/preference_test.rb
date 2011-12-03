require 'test_helper'

class PreferenceTest < ActiveSupport::TestCase
  test "rating must not be null" do
    test_attribute_may_not_be_null preferences(:one), :rating
  end

  test "rating must be between 0 and 5" do
    #TODO: implement this
    assert preferences(:one).valid?
    for number in MANY_NONINTEGERS
      preferences(:one).rating = number
      assert preferences(:one).invalid?
      assert preferences(:one).errors[:rating].include? "must be an integer"
    end
    for number in [-1,6,7]
      preferences(:one).rating = number
      assert preferences(:one).invalid?
      assert preferences(:one).errors[:rating].include? "must be 0 - 5"
    end
    for number in [0,1,2,3,4,5]
      preferences(:one).rating = number
      assert preferences(:one).valid?
    end
  end

end

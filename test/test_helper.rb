ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require File.join(File.dirname(__FILE__), '../time_provider')

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Sets the time provider to use mock time
  TimeProvider.set_mock_mode

  MANY_INTEGERS = [-23,-3,-1,0,1,2,3,10,200]
  MANY_NEGATIVE_INTEGERS = [-23,-13,-6,-4,-3,-1]
  MANY_NONNEGATIVE_INTEGERS = [0,1,2,3,5,10,52,200]
  MANY_NONINTEGERS = [-9.99, -2.34, -0.2, 0.2, 1.5, 2.0, 2.7, 6.4, 12.5]

  def test_attribute_may_not_be_null(model, attribute)
    assert model.valid?
    model[attribute] = nil
    assert model.invalid?
  end

  def test_attribute_must_be_unique(model, attribute)
    assert model.invalid?
    model[attribute] = "unique"
    assert model.valid?
  end
  
  def test_attribute_must_be_nonnegative(model, attribute)
    assert model.valid?
    for number in MANY_NEGATIVE_INTEGERS
      model[attribute] = number
      assert model.invalid?
      assert model.errors[attribute].include? "must be greater than or equal to 0"
    end
  end
  
  def test_attribute_must_be_null_or_nonnegative_integer(model, attribute)
    assert model.valid?
    model[attribute] = nil
    assert model.valid?
    for number in MANY_NONINTEGERS
      model[attribute] = number
      assert model.invalid?
      assert model.errors[attribute].include? "must be an integer"
    end
    for number in MANY_NEGATIVE_INTEGERS
      model[attribute] = number
      assert model.invalid?
      assert model.errors[attribute].include? "must be greater than or equal to 0"
    end
  end
  
end

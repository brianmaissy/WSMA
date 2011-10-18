ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  def many_integers
    [-23,-3,-1,0,1,2,3,10,200]
  end
  def many_negative_integers
    [-23,-13,-6,-4,-3,-1]
  end
  def many_nonnegative_integers
    [0,1,2,3,5,10,52,200]
  end
  def many_non_integers
    [-9.99, -2.34, -0.2, 0.2, 1.5, 2.0, 2.7, 6.4, 12.5]
  end
  
end

require 'test_helper'

class TimeProviderTest < ActiveSupport::TestCase

  test "starts in mock mode while testing" do
    time = TimeProvider.now
    assert_equal(time, TimeProvider.now)
  end

  test "gives moving time in normal mode" do
    TimeProvider.set_mock_mode(false)
    time = TimeProvider.now
    assert_not_equal(time, TimeProvider.now)
  end

  test "gives real time in normal mode" do
    TimeProvider.set_mock_mode(false)
    time = TimeProvider.now
    assert(Time.now - time < 1, "difference between TimeProvider's time and Time's time differ by more than a second")
  end

  test "advance time works" do
    TimeProvider.set_mock_time
    time = TimeProvider.now
    TimeProvider.advance_mock_time_by_hours(4)
    assert_equal(TimeProvider.now - time, 4.hours)
    TimeProvider.advance_mock_time_by_hours(-8)
    assert_equal(TimeProvider.now - time, -4.hours)
  end

  def teardown
    # return to mock mode when we're done
    TimeProvider.set_mock_mode
  end

end
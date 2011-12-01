require 'test_helper'

class TimeProviderTest < ActiveSupport::TestCase

  setup do
    TimeProvider.unschedule_all_tasks
  end

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
    TimeProvider.advance_mock_time 4.hours
    assert_equal(time + 4.hours, TimeProvider.now)
    TimeProvider.advance_mock_time -8.hours
    assert_equal(time - 4.hours, TimeProvider.now)
  end

  test "in normal mode, scheduling a task soon works" do
    TimeProvider.set_mock_mode false
    task_called = false
    TimeProvider.schedule_task_at TimeProvider.now+0.5.seconds, "test" do
      task_called = true
    end
    assert !task_called
    sleep(0.5)
    assert task_called
  end

  test "in mock mode scheduling a task works" do
    task_called = false
    TimeProvider.schedule_task_at TimeProvider.now+0.2.seconds, "test" do
      task_called = true
    end
    assert !task_called
    sleep(0.5)
    assert !task_called
    TimeProvider.advance_mock_time 1.second
    assert task_called
  end

  test "in normal mode canceling a task works" do
    TimeProvider.set_mock_mode false
    task_called = false
    TimeProvider.schedule_task_at TimeProvider.now+0.5.seconds, "test" do
      task_called = true
    end
    TimeProvider.unschedule_task "test"
    sleep(0.5)
    assert !task_called
    TimeProvider.schedule_task_at TimeProvider.now+0.5.seconds, "test1" do
      task_called = true
    end
    TimeProvider.unschedule_task "test"
    sleep(0.5)
    assert task_called
  end

  test "in mock mode canceling a task works" do
    task_called = false
    TimeProvider.schedule_task_at TimeProvider.now+0.2.seconds, "test" do
      task_called = true
    end
    TimeProvider.unschedule_task "test"
    TimeProvider.advance_mock_time 1.second
    assert !task_called
    TimeProvider.schedule_task_at TimeProvider.now+0.2.seconds, "test1" do
      task_called = true
    end
    TimeProvider.unschedule_task "test"
    TimeProvider.advance_mock_time 1.second
    assert task_called
  end

  test "in normal mode canceling all tasks works" do
    TimeProvider.set_mock_mode false
    TimeProvider.schedule_task_at TimeProvider.now+1.minute, "test" do end
    TimeProvider.schedule_task_at TimeProvider.now+1.minute, "test1" do end
    count = TimeProvider.task_count
    TimeProvider.unschedule_all_tasks
    assert_equal(count-2, TimeProvider.task_count)
  end

  test "in mock mode canceling all tasks works" do
    TimeProvider.schedule_task_at TimeProvider.now+1.minute, "test" do end
    TimeProvider.schedule_task_at TimeProvider.now+1.minute, "test1" do end
    count = TimeProvider.task_count
    TimeProvider.unschedule_all_tasks
    assert_equal(count-2, TimeProvider.task_count)
  end

  test "generate job tags" do
    house = houses(:one)
    assignment = assignments(:one)
    fining_period = fining_periods(:one)
    assert_equal("House" + house.id.to_s, TimeProvider.generate_job_tag(house))
    assert_equal("Assignment" + assignment.id.to_s, TimeProvider.generate_job_tag(assignment))
    assert_equal("FiningPeriod" + fining_period.id.to_s, TimeProvider.generate_job_tag(fining_period))
  end

  def teardown
    # return to mock mode when we're done
    TimeProvider.set_mock_mode
    TimeProvider.unschedule_all_tasks
  end

end
require 'rufus-scheduler'

# provides a layer of indirection to accessing the system time, and contains mocking features for testing
# nothing in the model or tests should call Time directly
class TimeProvider

  @@in_mock_mode = false

  @@current_mock_time = nil

  @@scheduler = Rufus::Scheduler::PlainScheduler.start_new
  @@task_table = []

  def self.set_mock_mode(mode = true)
    @@in_mock_mode = mode
  end

  def self.now
    if @@in_mock_mode
      if not @@current_mock_time
        #if it's not set up yet, they don't care about the current time
        #fail nicely with a good default
        set_mock_time
      end
      return @@current_mock_time
    else
      return Time.now
    end
  end

  def self.schedule_task_at task_time, &task_block
    if @@in_mock_mode
      @@task_table << [task_time, task_block]
    else
      @@scheduler.at task_time, &task_block
    end
  end

  def self.set_mock_time(time = Time.now)
    @@current_mock_time = time
    run_tasks
  end
  def self.advance_mock_time_by_seconds(seconds)
    @@current_mock_time += seconds
    run_tasks
  end
  def self.advance_mock_time_by_minutes(minutes)
    @@current_mock_time += minutes * 60
    run_tasks
  end
  def self.advance_mock_time_by_hours(hours)
    @@current_mock_time += hours * 3600
    run_tasks
  end
  def self.advance_mock_time_by_days(days)
    @@current_mock_time += days * 24 * 3600
    run_tasks
  end

  def self.run_tasks
    if @@in_mock_mode
      tasks_to_run = []
      for task in @@task_table
        if task[0] < @@current_mock_time
          tasks_to_run << task
        end
      end
      for task in tasks_to_run
        task[1].call()
        @@task_table.delete(task)
        a = 1
      end
    end
  end

end
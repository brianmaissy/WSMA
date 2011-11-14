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
      return DateTime.now
    end
  end

  def self.set_mock_time(time = DateTime.now)
    @@current_mock_time = time
    run_tasks
  end
  def self.advance_mock_time(duration)
    @@current_mock_time += duration
    run_tasks
  end

  def self.schedule_task_at task_time, tag, &task_block
    if @@in_mock_mode
      @@task_table << [task_time, tag, task_block]
    else
      if task_time.is_a? DateTime
        task_time = Time.gm(task_time.year, task_time.month, task_time.day, task_time.hour, task_time.min, task_time.sec, task_time.zone)
      end
      @@scheduler.at task_time, :tags => tag, &task_block
    end
  end

  def self.unschedule_task tag
    if @@in_mock_mode
      tasks_to_delete = []
      for task in @@task_table
        if task[1] == tag
          tasks_to_delete << task
        end
      end
      for task in tasks_to_delete
        @@task_table.delete(task)
      end
    else
      tasks_to_delete = @@scheduler.find_by_tag(tag)
      for task in tasks_to_delete
        task.unschedule
      end
    end
  end

  def self.task_count
    if @@in_mock_mode
      return @@task_table.size
    else
      @@scheduler.all_jobs.size
    end
  end

  def self.unschedule_all_tasks
    if @@in_mock_mode
      @@task_table = []
    else
      for job in @@scheduler.all_jobs.values
        job.unschedule
      end
    end
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
        task[2].call()
        @@task_table.delete(task)
      end
    end
  end

  def self.generate_job_tag(model_instance)
    return model_instance.class.to_s + model_instance.id.to_s
  end

end
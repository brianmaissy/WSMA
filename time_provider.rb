# provides a layer of indirection to accessing the system time, and contains mocking features for testing
# nothing in the model or tests should call Time directly
class TimeProvider

  @@in_mock_mode = false
  @@current_mock_time = nil

  def self.set_mock_mode(mode = true)
    @@in_mock_mode = mode
  end

  def self.get_current_server_time
    if @@in_mock_mode
      if not @@current_mock_time
        set_mock_time
      end
      return @@current_mock_time
    else
      return Time.now
    end
  end

  def self.set_mock_time(time = Time.now)
    @@current_mock_time = time
  end

  def self.advance_mock_time_by_hours(hours)
    @@current_mock_time += hours * 3600
  end

  def self.advance_mock_time_by_days(days)
    @@current_mock_time += days * 24 * 3600
  end

end
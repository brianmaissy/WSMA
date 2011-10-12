class User < ActiveRecord::Base

  after_initialize :initialize_defaults
  
  validates_presence_of :email, :hashed_password, :salt, :access_level, :hours_per_week
  validates_numericality_of :hours_per_week
  validates_uniqueness_of :email
  validate :access_level_has_legal_value
  validate :hours_per_week_has_legal_value

  def access_level_has_legal_value
    errors.add(:access_level, 'must be 1, 2, or 3' ) if not [1, 2, 3].include? access_level
  end
  
  def hours_per_week_has_legal_value
    errors.add(:hours_per_week, 'must be nonnegative' ) if hours_per_week < 0
  end

  def initialize_defaults
    if new_record?
      #TODO: take value from House instead of 5
      self.hours_per_week = 5 if self.hours_per_week.nil?
    end
  end

  def authenticate(encrypted_password, public_key)
    #TODO: implement this
    raise NotImplementedError
  end
  
  def hour_balance
    #TODO: implement this
    raise NotImplementedError
  end
  
  def total_allocated_hours
    #TODO: implement this
    raise NotImplementedError
  end
  
  def assigned_hours_this_week
    #TODO: implement this
    raise NotImplementedError
  end
  
  def completed_hours_this_week
    #TODO: implement this
    raise NotImplementedError
  end
  
  def pending_hours_this_week
    #TODO: implement this
    raise NotImplementedError
  end
  
  def hours_required_this_week
    #TODO: implement this
    raise NotImplementedError
  end
  
  def hours_required_for_week(week)
    #TODO: implement this
    raise NotImplementedError
  end
  
  def change_password(encrypted_new_password, public_key)
    #TODO: implement this
    raise NotImplementedError
  end
  
  def send_reset_password_email
    #TODO: implement this
    raise NotImplementedError
  end
  
end

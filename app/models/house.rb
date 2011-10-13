class House < ActiveRecord::Base

  after_initialize :initialize_defaults
  before_destroy :cancel_jobs
  
  validates_presence_of :name, :using_online_sign_off, :sign_off_verification_mode
  validates_numericality_of :hours_per_week, :sign_off_by_hours_after, :blow_off_penalty_factor
  validates_numericality_of :permanent_chores_start_week, :allow_nil => true
  #TODO: find a way to do date validation
  #validates_datetime :semester_start_date
  validates_uniqueness_of :name
  validate :using_online_sign_off_has_legal_value
  validate :sign_off_verification_mode_has_legal_value

  def using_online_sign_off_has_legal_value
    errors.add(:using_online_sign_off, 'must be 0 or 1' ) if not [0, 1].include? using_online_sign_off
  end
  
  def sign_off_verification_mode_has_legal_value
    errors.add(:sign_off_verification_mode, 'must be 0, 1, or 2' ) if not [0, 1, 2].include? sign_off_verification_mode
  end

  def initialize_defaults
    if new_record?
      self.hours_per_week = 0 if self.hours_per_week.nil?
      self.sign_off_by_hours_after = 0 if self.sign_off_by_hours_after.nil?
      self.blow_off_penalty_factor = 0 if self.blow_off_penalty_factor.nil?
      self.using_online_sign_off = 1 if self.using_online_sign_off.nil?
      self.sign_off_verification_mode = 2 if self.sign_off_verification_mode.nil?
    end
  end

  def cancel_jobs
    #TODO: implement this
  end

  def import(roster_csv)
    #TODO: implement this
    raise NotImplementedError
  end
  
  def permanent_chores_start_week=(week)
    super(week)
    #TODO: implement this
  end
  
  def current_week
    #TODO: implement this
    raise NotImplementedError
  end
  
  def start_new_week
    #TODO: implement this
    raise NotImplementedError
  end
  
  def available_shifts
    #TODO: implement this
    raise NotImplementedError
  end

end

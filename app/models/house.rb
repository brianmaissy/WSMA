class House < ActiveRecord::Base

  has_many :users, :dependent => :destroy
  has_many :chores, :dependent => :destroy
  has_many :shifts, :through => :chores
  has_many :house_hour_requirements, :dependent => :destroy
  has_many :fining_periods, :dependent => :destroy

  after_initialize :initialize_defaults
  after_save :semester_start_date_modified
  before_destroy :cancel_jobs
  
  validates_presence_of :name, :using_online_sign_off, :sign_off_verification_mode
  validates_numericality_of :hours_per_week, :sign_off_by_hours_after, :current_week,
                            :blow_off_penalty_factor, :greater_than_or_equal_to => 0
  validates_numericality_of :permanent_chores_start_week, :allow_nil => true, :only_integer => true, :greater_than_or_equal_to => 1
  validates_numericality_of :using_online_sign_off, :sign_off_verification_mode, :only_integer => true
  validates_uniqueness_of :name
  validate :using_online_sign_off_has_legal_value
  validate :sign_off_verification_mode_has_legal_value
	validate :email_is_valid_or_nil
  validate :current_week_cannot_decrease
  validate :permanent_chores_start_week_must_be_in_future
  validate :new_and_old_semester_end_date_must_be_in_future
  validate :new_and_old_semester_start_date_must_be_in_future

  def using_online_sign_off_has_legal_value
    errors.add(:using_online_sign_off, 'must be 0 or 1' ) if not [0, 1].include? using_online_sign_off
  end
  
  def sign_off_verification_mode_has_legal_value
    errors.add(:sign_off_verification_mode, 'must be 0, 1, or 2' ) if not [0, 1, 2].include? sign_off_verification_mode
  end

	def email_is_valid_or_nil
    # This regex is from http://www.regular-expressions.info/email.html, read there for more information
    re = Regexp.new("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", Regexp::IGNORECASE)
    errors.add(:wsm_email, 'must be a valid email' ) unless wsm_email.blank? or re.match wsm_email
  end
  
  def current_week_cannot_decrease
    errors.add(:current_week, 'cannot be decreased' ) if not current_week.blank? and current_week_changed? and current_week < (current_week_was || 0)
  end

  def permanent_chores_start_week_must_be_in_future
    errors.add(:permanent_chores_start_week, 'must be in the future' ) if not permanent_chores_start_week.blank? and permanent_chores_start_week_changed? and permanent_chores_start_week <= current_week
  end

  def new_and_old_semester_start_date_must_be_in_future
    errors.add(:semester_start_date, 'cannot be changed; semester is already begun') if not semester_start_date.blank? and semester_start_date_changed? and not semester_start_date_was.blank? and semester_start_date_was <= TimeProvider.now
    errors.add(:semester_start_date, 'must be in the future' ) if not semester_start_date.blank? and semester_start_date_changed? and semester_start_date <= TimeProvider.now
  end

  def new_and_old_semester_end_date_must_be_in_future
    errors.add(:semester_end_date, 'cannot be changed; semester is already over') if not semester_end_date.blank? and semester_end_date_changed? and not semester_end_date_was.blank? and semester_end_date_was <= TimeProvider.now
    errors.add(:semester_end_date, 'must be in the future' ) if not semester_end_date.blank? and semester_end_date_changed? and semester_end_date <= TimeProvider.now
  end

  def initialize_defaults
    if new_record?
      self.hours_per_week = 0 if hours_per_week.nil?
      self.sign_off_by_hours_after = 0 if sign_off_by_hours_after.nil?
      self.blow_off_penalty_factor = 0 if blow_off_penalty_factor.nil?
      self.using_online_sign_off = 1 if using_online_sign_off.nil?
      self.sign_off_verification_mode = 2 if sign_off_verification_mode.nil?
      self.current_week = 0 if current_week.nil?
      self.permanent_chores_start_week = 1 if permanent_chores_start_week.nil?
    end
  end

  def semester_start_date_modified
    if semester_start_date_changed?
      cancel_jobs
      schedule_new_week_job next_sunday_at_midnight semester_start_date
    end
  end

  def schedule_new_week_job new_week_time
    tag = TimeProvider.generate_job_tag(self)
    TimeProvider.schedule_execute_at(new_week_time, tag, self.class.to_s, self.id)
  end

  def cancel_jobs
    tag = TimeProvider.generate_job_tag(self)
    TimeProvider.unschedule_task tag
  end

  def execute_job
    if semester_end_date and TimeProvider.now < semester_end_date
      start_new_week
      if TimeProvider.now + 7.days < semester_end_date
        schedule_new_week_job next_sunday_at_midnight(TimeProvider.now)
      end
    end
  end

  def start_new_week
    self.current_week += 1
    if permanent_chores_start_week and current_week >= permanent_chores_start_week
      shifts.all.each do |shift|
        if shift.user
          assignment = Assignment.create(:shift => shift, :user => shift.user, :week => current_week)
        end
      end
    end
    self.save!
  end

  def beginning_of_this_week current
    current = DateTime.parse(current.to_s)
    beginning = current.advance(:hours => -current.hour, :minutes => -current.min, :seconds => -current.sec)
    return beginning.advance(:days => -current.wday)
  end

  def end_of_this_week current
    end_of_week current_week
  end

  def end_of_week week
    next_sunday_at_midnight(TimeProvider.now).advance(:days => 7 * (week - current_week))
  end

  def next_sunday_at_midnight current
    current = DateTime.parse(current.to_s)
    beginning = beginning_of_this_week current
    return beginning.advance(:days => 7)
  end

  def unassigned_shifts
    unassigned = []
    shifts.all.each do |shift|
      if shift.assignments.where(:week => current_week).length == 0
        unassigned << shift
      end
    end
    return unassigned
  end

  def unallocated_shifts
    return shifts.where(:user_id => nil, :temporary => 0)
  end

  def import(roster_csv)
    #TODO: implement this (iteration 3)
    raise NotImplementedError
  end

end

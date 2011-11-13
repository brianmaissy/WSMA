class House < ActiveRecord::Base

  has_many :users, :dependent => :destroy
  has_many :chores, :dependent => :destroy
  has_many :shifts, :through => :chores
  has_many :house_hour_requirements, :dependent => :destroy
  has_many :chores
  has_many :shifts, :through => :chores
  has_many :fining_periods
  has_many :house_hour_requirements

  after_initialize :initialize_defaults
  before_destroy :cancel_jobs
  
  validates_presence_of :name, :using_online_sign_off, :sign_off_verification_mode
  validates_numericality_of :hours_per_week, :sign_off_by_hours_after, :current_week,
                            :blow_off_penalty_factor, :greater_than_or_equal_to => 0
  validates_numericality_of :permanent_chores_start_week, :allow_nil => true, :only_integer => true, :greater_than_or_equal_to => 0 
  validates_numericality_of :using_online_sign_off, :sign_off_verification_mode, :only_integer => true
  #TODO: find a way to do date validation
  #validates_datetime :semester_start_date, :semester_end_date
  #validate end date is after start date
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
      self.hours_per_week = 0 if hours_per_week.nil?
      self.sign_off_by_hours_after = 0 if sign_off_by_hours_after.nil?
      self.blow_off_penalty_factor = 0 if blow_off_penalty_factor.nil?
      self.using_online_sign_off = 1 if using_online_sign_off.nil?
      self.sign_off_verification_mode = 2 if sign_off_verification_mode.nil?
      self.current_week = 0 if current_week.nil?
    end
  end

  def cancel_jobs
    #TODO: implement this
  end

  def import(roster_csv)
    #TODO: implement this (iteration 3)
    raise NotImplementedError
  end
  
  def semester_start_date=(date)
    super(date)
    #TODO: implement this
  end

  def new_week_job
    if semester_end_date and TimeProvider.now < semester_end_date
      start_new_week
      if TimeProvider.now + 7.days < semester_end_date
        schedule_new_week_job next_sunday_at_midnight(TimeProvider.now)
      end
    end
  end

  def schedule_new_week_job new_week_time
    tag = TimeProvider.generate_job_tag(self)
    TimeProvider.schedule_task_at(new_week_time, tag) {new_week_job}
    new_week_job_id= tag
  end

  def next_sunday_at_midnight current
    return DateTime.new(current.year, current.month, current.day + (7-current.wday), 0, 0, 0, 0)
  end

  def start_new_week
    self.current_week += 1
    if permanent_chores_start_week and current_week >= permanent_chores_start_week
      shifts.all.each do |shift|
        if shift.user
          assignment = Assignment.new(:shift => shift, :user => shift.user, :week => current_week)
          if using_online_sign_off == 1
            assignment.status= 1
            assignment.blow_off_job_id="placeholder"
            assignment.save
            blow_off_time = shift.time + shift.chore.due_hours_after + shift.user.house.sign_off_by_hours_after
            assignment.schedule_blow_off_job blow_off_time
          else
            assignment.status= 2
            assignment.save
          end
        end
      end
    end
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

end

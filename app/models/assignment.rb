class Assignment < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :shift
  has_one :house, :through => :user
  has_one :chore, :through => :shift

  before_validation :initialize_status
  after_create :schedule_blow_off_job
  before_destroy :cancel_jobs

  validates_presence_of :week, :status
  validates_numericality_of :week, :greater_than_or_equal_to => 0
  validates_uniqueness_of :shift_id, :scope => [:week]
  validates_numericality_of :status, :only_integer => true
  validate :status_has_legal_value

  def status_has_legal_value
    errors.add(:status, 'must be 1, 2, or 3' ) if not [1, 2, 3].include? status
  end
  
  def initialize_status
    if new_record? and status.nil?
      if house.using_online_sign_off == 1
        self.status = 1
      else
        self.status = 2
      end
    end
  end

  def schedule_blow_off_job
    if house.using_online_sign_off == 1
      tag = TimeProvider.generate_job_tag(self)
      TimeProvider.schedule_execute_at(shift.blow_off_time, tag, self.class.to_s, self.id)
    end
  end

  def cancel_jobs
    tag = TimeProvider.generate_job_tag(self)
    TimeProvider.unschedule_task tag
  end

  def execute_job
    self.status = 3
    self.save!
  end

  def sign_off(*a)
    case a.length
    when 0
      if house.using_online_sign_off == 1 and house.sign_off_verification_mode == 0 and self.status == 1
        self.status = 2
        self.save!
      else
        raise ArgumentError
      end
  
    when 1
      if house.using_online_sign_off == 1 and house.sign_off_verification_mode == 1 and self.status == 1
        self.status = 2
        self.save!
        @user = a[0]
        UserMailer.verification_email(@user).deliver
      else
        raise ArgumentError
      end
    
    when 2
      if house.using_online_sign_off == 1 and house.sign_off_verification_mode == 2 and self.status == 1
        @user = a[0]
        @password = a[1]
        if @user and @user.password.eql? @password
          self.status = 2
          self.save!
        else
          raise ArgumentError, 'Invalid email/password combination'
        end
      else
        raise ArgumentError
      end
      
    else
      raise ArgumentError
    end

  end
  
  def sign_out
    if self.status == 1
      Assignment.destroy(self)
    else
      raise ArgumentError
    end
  end
  
end

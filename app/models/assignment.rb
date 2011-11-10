class Assignment < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :shift
  has_one :house, :through => :user
  has_one :chore, :through => :shift
  
  validates_presence_of :week, :status
  validates_presence_of :blow_off_job_id, :unless => Proc.new{Shift.find(shift_id).chore.house.using_online_sign_off == 0}
  validates_numericality_of :week, :greater_than_or_equal_to => 0
  validates_numericality_of :status, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 3
  validates_uniqueness_of :shift_id, :scope => [:week]
  
  def initialize_defaults
    #TODO: implement this
  end

  def schedule_blow_off_job blow_off_time
    tag = TimeProvider.generate_job_tag(self)
    TimeProvider.schedule_task_at(blow_off_time, tag) {blow_off_job}
    blow_off_job_id= tag
  end

  def cancel_jobs
    #TODO: implement this
  end

  def blow_off_job
    #TODO: implement this
  end

  def sign_off(*a)
    case a.length
    when 0
      if house.using_online_sign_off == 1 and house.sign_off_verification_mode == 0 and self.status == 1
        self.status = 2
      else
        raise ArgumentError
      end
  
    when 1
      if house.using_online_sign_off == 1 and house.sign_off_verification_mode == 1 and self.status == 1
        self.status = 2
        #TODO: send email to user
      else
        raise ArgumentError
      end
    
    when 3
      if house.using_online_sign_off == 1 and house.sign_off_verification_mode == 2 and self.status == 1
        self.status = 2
      else
        raise ArgumentError
      end
      
    else
      puts 'im here'
      raise ArgumentError
    end
    
  end
  
  def sign_out
    #TODO: implement this
  end
  
end

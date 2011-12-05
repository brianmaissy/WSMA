class FiningPeriod < ActiveRecord::Base
  
  after_initialize :initialize_defaults
  
  belongs_to :house
  has_many :fines, :dependent => :destroy
  
  validates_presence_of :fining_week, :fine_for_hours_below, :fine_per_hour_below, :forgive_percentage_of_fined_hours
  
  validates_numericality_of :fining_week, :fine_per_hour_below, :greater_than_or_equal_to => 0
  
  validates_numericality_of :fine_for_hours_below, :less_than_or_equal_to => 0
  
  validates_numericality_of :forgive_percentage_of_fined_hours, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1
  
  def initialize_defaults
    tag = TimeProvider.generate_job_tag(self)
    TimeProvider.schedule_execute_at(calculate_fines_time, tag, self.class.to_s, self.id)
  end
  
  def execute_job
    calculate_fines
  end
  
  def calculate_fines_time
    return house.end_of_week(fining_week).advance(:hours => house.sign_off_by_hours_after.to_r)
  end
  
  def cancel_jobs
    tag = TimeProvider.generate_job_tag(self)
    TimeProvider.unschedule_task tag
  end
  
  def calculate_fines
    house.users.all.each do |u|
      if u.hour_balance < self.fine_for_hours_below
        f = Fine.create(:user => u, :amount => (fine_for_hours_below - u.hour_balance)*fine_per_hour_below, :paid => 0, :paid_date => nil, :hours_fined_for => (fine_for_hours_below - u.hour_balance))
      end
    end
  end
  
end

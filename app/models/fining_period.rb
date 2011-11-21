class FiningPeriod < ActiveRecord::Base
  
  after_initialize :initialize_defaults
  
  belongs_to :house
  has_many :fines
  
  validates_presence_of :fining_week, :fine_for_hours_below, :fine_per_hour_below, :forgive_percentage_of_fined_hours, :fine_job_id
  
  validates_numericality_of :fining_week, :fine_per_hour_below, :greater_than_or_equal_to => 0
  
  validates_numericality_of :fine_for_hours_below, :less_than_or_equal_to => 0
  
  validates_numericality_of :forgive_percentage_of_fined_hours, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1
  
  def initialize_defaults
    #TODO: implement this
    #creates a Rufus-scheduler job which will run calculate_fines at House.sign_off_by_hours_after hours after the end of fining_week
    #stores the job id in the fine_job_id field
  end
  
  def cancel_jobs
    #TODO: implement this
  end
  
  def calculate_fines
    house.users.all.each do |u|
      if u.hour_balance < self.fine_for_hours_below
        f = Fine.create(:user => u, :amount => (fine_for_hours_below - u.hour_balance)*fine_per_hour_below, :paid => 0, :paid_date => nil, :hours_fined_for => (fine_for_hours_below - u.hour_balance))
      end
    end
  end
  
end

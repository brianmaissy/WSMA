class FiningPeriod < ActiveRecord::Base
  
  belongs_to :house
  has_many :fines, :dependent => :destroy
  
  validates_presence_of :fining_week, :fine_for_hours_below, :fine_per_hour_below, :forgive_percentage_of_fined_hours
  
  validates_numericality_of :fining_week, :fine_per_hour_below, :greater_than_or_equal_to => 0
  
  validates_numericality_of :fine_for_hours_below, :less_than_or_equal_to => 0
  
  validates_numericality_of :forgive_percentage_of_fined_hours, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1
  
  def initialize_defaults
    #TODO: implement this
  end
  
  def cancel_jobs
    #TODO: implement this
  end
  
  def calculate_fines
    #TODO: implement this
  end
  
end

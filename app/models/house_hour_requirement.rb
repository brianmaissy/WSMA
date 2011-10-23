class HouseHourRequirement < ActiveRecord::Base
  belongs_to :house
  
  validates_presence_of :week, :hours
  validates_numericality_of :week, :hours, :greater_than_or_equal_to => 0
  validates_uniqueness_of :week, :scope => [:house_id]
  
  def initialize(house, week, hours)
    #TODO: implement this
  end
  
end

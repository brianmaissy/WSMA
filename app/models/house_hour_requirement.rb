class HouseHourRequirement < ActiveRecord::Base
  belongs_to :house
  
  validates_uniqueness_of :week, :scope => [:house_id]
end

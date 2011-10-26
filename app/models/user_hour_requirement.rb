class UserHourRequirement < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :week, :hours
  validates_numericality_of :week, :hours, :greater_than_or_equal_to => 0
  validates_uniqueness_of :week, :scope => [:user_id]
  
end

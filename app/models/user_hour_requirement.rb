class UserHourRequirement < ActiveRecord::Base
  belongs_to :user
  
  validates_uniqueness_of :week, :scope => [:user_id]
end

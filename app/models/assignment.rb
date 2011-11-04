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
  
  def cancel_jobs
    #TODO: implement this
  end
  
  def sign_off
    #TODO: implement this
  end
  
  def sign_off(user)
    #TODO: implement this
  end
  
  def sign_off(user, encrypted_password, public_key)
    #TODO: implement this
  end
  
  def sign_out
    #TODO: implement this
  end
  
end

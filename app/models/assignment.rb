class Assignment < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :shift
  belongs_to :house
  belongs_to :chore
  
  validates_presence_of :week, :status, :blow_off_job_id
  validates_numericality_of :week :greater_than_or_equl_to => 0
  validates_numericality_of :status :greater_than_or_equl_to => 1, :less_than_or_equal_to => 3
  
  def initialize(user, shift, week, status)
    #TODO: implement this
  end
  
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

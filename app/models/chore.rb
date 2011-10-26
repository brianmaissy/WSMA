class Chore < ActiveRecord::Base
  
  belongs_to :house
  has_many :shifts
  
  validates_presence_of :name, :hours, :sign_out_by_hours_before, :due_hours_after
  
  validates_numericality_of :hours, :sign_out_by_hours_before, :greater_than_or_equal_to => 0
  
  validates_numericality_of :due_hours_after, :greater_than_or_equal_to => :hours, :less_than_or_equal_to => 168
  
  def initialize_defaults
    if new_record?
      self.sign_out_by_hours_before = 0 if self.sign_out_by_hours_before.nil?
      self.due_hours_after = hours if self.due_hours_after.nil?
    end
  end
  
end

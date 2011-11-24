class Chore < ActiveRecord::Base
  
  belongs_to :house
  has_many :shifts, :dependent => :destroy
  
  after_initialize :initialize_defaults
  
  validates_presence_of :name, :hours, :sign_out_by_hours_before, :due_hours_after
  validates_numericality_of :hours, :greater_than_or_equal_to => 0, :unless => Proc.new{self.hours.nil?}
  validates_numericality_of :sign_out_by_hours_before, :greater_than_or_equal_to => 0, :unless => Proc.new{sign_out_by_hours_before.nil?}
  validates_numericality_of :due_hours_after, :greater_than_or_equal_to => :hours, :less_than_or_equal_to => 168, :unless => Proc.new{self.hours.nil? or self.due_hours_after.nil?}
  
  def initialize_defaults
    if new_record?
      self.sign_out_by_hours_before = 0 if self.sign_out_by_hours_before.nil?
      self.due_hours_after = self.hours if self.due_hours_after.nil?
    end
  end
  
end

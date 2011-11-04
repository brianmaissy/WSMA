class Shift < ActiveRecord::Base
  
  belongs_to :chore
  belongs_to :user
  has_many :assignments
  
  validates_presence_of :day_of_week, :time, :temporary
  validates_numericality_of :day_of_week, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 7
  #TODO: find a way to do time validation
  #validates_time :time
  validate :temporary_has_legal_value
  validate :temporary_shifts_cannot_be_allocated
  
  def temporary_has_legal_value
    errors.add(:temporary, 'must be 0 or 1') if not [0, 1].include? temporary
  end

  def temporary_shifts_cannot_be_allocated
    errors[:base] << ("temporary shifts cannot be allocated to a user") if temporary==1 and not user.nil?
  end

end

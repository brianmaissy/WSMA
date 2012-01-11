class Shift < ActiveRecord::Base
  
  belongs_to :chore
  belongs_to :user
  has_many :assignments, :dependent => :destroy
  has_one :house, :through => :chore
  
  validates_presence_of :day_of_week, :time, :temporary
  validates_numericality_of :day_of_week, :temporary, :only_integer => true
  validate :temporary_has_legal_value
  validate :day_of_week_has_legal_value
  validate :temporary_shifts_cannot_be_allocated
  
  def temporary_has_legal_value
    errors.add(:temporary, 'must be 0 or 1') if not [0, 1].include? temporary
  end
  
  def day_of_week_has_legal_value
    errors.add(:day_of_week, 'must be 1 - 7') if not [1,2,3,4,5,6,7].include? day_of_week
  end
    
  def temporary_shifts_cannot_be_allocated
    errors[:base] << ("temporary shifts cannot be allocated to a user") if temporary==1 and not user.nil?
  end

  def start_time_this_week
    house.beginning_of_this_week(TimeProvider.now).advance(:days => day_of_week.to_f-1, :hours => time.hour.to_f, :minutes => time.min.to_f)
  end

  def end_time_this_week
    start_time_this_week.advance(:hours => chore.hours.to_f)
  end

  def blow_off_time_this_week
    end_time_this_week.advance(:hours => chore.due_hours_after.to_f + house.sign_off_by_hours_after.to_f)
  end

end

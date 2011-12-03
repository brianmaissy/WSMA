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
    start = house.beginning_of_this_week(TimeProvider.now)
    start += day_of_week.days
    start += time.hour.hours
    start += time.min.minutes
    return start
  end

  def blow_off_time
    blow_off = start_time_this_week
    blow_off = blow_off.advance(:hours => chore.hours.to_f)
    blow_off = blow_off.advance(:hours => chore.due_hours_after.to_f)
    blow_off = blow_off.advance(:hours => house.sign_off_by_hours_after.to_f)
    return blow_off
  end

end

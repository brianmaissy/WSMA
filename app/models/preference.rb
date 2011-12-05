class Preference < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :shift
  
  validates_numericality_of :rating, :only_integer => true
  validate :rating_has_legal_value
  
  def rating_has_legal_value
    errors.add(:rating, 'must be 0 - 5' ) if not [0, 1, 2, 3, 4, 5].include? rating
  end
  
end

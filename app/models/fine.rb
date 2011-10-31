class Fine < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :fining_period
  
  validates_presence_of :amount, :paid, :hours_fined_for
  validates_numericality_of :amount, :greater_than => 0
  validate :paid_has_legal_value
  
  def paid_has_legal_value
    errors.add(:paid, 'must be 0 or 1' ) if not [0, 1].include? paid
  end
  
end

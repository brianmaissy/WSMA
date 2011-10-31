require 'bcrypt'

class User < ActiveRecord::Base

  include BCrypt

  belongs_to :house
  has_many :user_hour_requirements, :dependent => :destroy

  after_initialize :initialize_defaults

  validates_presence_of :house_id, :email, :name, :access_level
  validate :presence_of_password
  validates_numericality_of :hours_per_week, :greater_than_or_equal_to => 0
  validates_numericality_of :access_level, :only_integer => true
  validates_uniqueness_of :email
  validate :access_level_has_legal_value

  def access_level_has_legal_value
    errors.add(:access_level, 'must be 1, 2, or 3' ) if not [1, 2, 3].include? access_level
  end

  def presence_of_password
    errors[:base] << ("Password can't be blank") if password_hash.nil?
  end

  def initialize_defaults
    if new_record? and not house.nil?
      self.hours_per_week = house.hours_per_week if self.hours_per_week.nil?
    end
  end

  def authenticate(encrypted_password, public_key)
    #TODO: implement this
    raise NotImplementedError
  end

  def self.create_random_password
    chars = [('a'..'z'),(0..9)].map{|i| i.to_a}.flatten
    return (0..12).map{ chars[rand(chars.length)] }.join
  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def hour_balance
    #TODO: implement this
    raise NotImplementedError
  end
  
  def total_allocated_hours
    #TODO: implement this
    raise NotImplementedError
  end
  
  def assigned_hours_this_week
    #TODO: implement this
    raise NotImplementedError
  end
  
  def completed_hours_this_week
    #TODO: implement this
    raise NotImplementedError
  end
  
  def pending_hours_this_week
    #TODO: implement this
    raise NotImplementedError
  end
  
  def hours_required_this_week
    return hours_required_for_week house.current_week
  end
  
  def hours_required_for_week(week)
    #TODO: implement this
    raise NotImplementedError
  end
  
  def change_password(encrypted_new_password, public_key)
    #TODO: implement this
    raise NotImplementedError
  end
  
  def send_reset_password_email
    #TODO: implement this
    raise NotImplementedError
  end
  
end

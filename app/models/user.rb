require 'bcrypt'

class User < ActiveRecord::Base

  include BCrypt

  belongs_to :house
  has_many :user_hour_requirements, :dependent => :destroy
  has_many :shifts
  has_many :assignments, :dependent => :destroy
  has_many :fines, :dependent => :destroy

  after_initialize :initialize_defaults

  validates_presence_of :house_id, :name, :access_level
  validate :presence_of_password
  validates_numericality_of :hours_per_week, :greater_than_or_equal_to => 0
  validates_numericality_of :access_level, :only_integer => true
  validates_uniqueness_of :email
  validate :email_is_valid
  validate :access_level_has_legal_value

  def email_is_valid
    # This regex is from http://www.regular-expressions.info/email.html, read there for more information
    re = Regexp.new("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", Regexp::IGNORECASE)
    errors.add(:email, 'must be a valid email' ) if not re.match email
  end

  def access_level_has_legal_value
    errors.add(:access_level, 'must be 1, 2, or 3' ) if not [1, 2, 3].include? access_level
  end

  def presence_of_password
    errors[:base] << ("Password can't be blank") if password_hash.blank? or password.nil? or password == ""
  end

  def initialize_defaults
    if new_record? and not house.nil?
      self.hours_per_week = house.hours_per_week if hours_per_week.nil?
    end
  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def self.create_random_password
    chars = [('a'..'z'),(0..9)].map{|i| i.to_a}.flatten
    return (0..12).map{ chars[rand(chars.length)] }.join
  end

  def send_reset_password_email
    self.password_reset_token = ActionController::HttpAuthentication::Digest.nonce(password_hash, TimeProvider.now)[1,20]
    self.token_expiration = TimeProvider.now.advance(:hours => 24)
    self.save!
    begin
      UserMailer.password_reset_email(self).deliver
    rescue Net::SMTPError
      self.token_expiration = TimeProvider.now
      self.save!
      return false
    end
    return true
  end

  def hour_balance
    balance = 0
    balance += assignments.where(:status => 2).all.sum { |a| a.chore.hours }
    balance -= assignments.where(:status => 3).all.sum { |a| a.chore.hours * house.blow_off_penalty_factor }
    balance -= (0...house.current_week).sum { |week| hours_required_for_week(week) }
    balance += fines.all.sum do |fine|
      if fine.fining_period
        fine.hours_fined_for * fine.fining_period.forgive_percentage_of_fined_hours
      else
        0
      end
    end
    balance
  end

  def total_allocated_hours
    shifts.all.sum { |s| s.chore.hours }
  end

  def assigned_hours_this_week
    assignments.where(:week => house.current_week).all.sum { |a| a.chore.hours }
  end

  def completed_hours_this_week
    assignments.where(:week => house.current_week, :status => 2).all.sum { |a| a.chore.hours }
  end

  def pending_hours_this_week
    assignments.where(:week => house.current_week, :status => 1).all.sum { |a| a.chore.hours }
  end

  def hours_required_this_week
    hours_required_for_week house.current_week
  end

  def hours_required_for_week(week)
    week = week.to_i
    raise ArgumentError if week < 0
    uhr = user_hour_requirements.where(:week => week).first
    hhr = house.house_hour_requirements.where(:week => week).first
    uhr_hours = uhr.hours if uhr
    hhr_hours = hhr.hours if hhr
    values = [uhr_hours, hhr_hours, hours_per_week, house.hours_per_week].collect do |a|
      if a.nil?
        1/0.0
      else
        a
      end
    end
    return values.min
  end

end

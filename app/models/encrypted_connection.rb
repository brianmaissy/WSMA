class EncryptedConnection < ActiveRecord::Base

  after_initialize :initialize_defaults
  
  validates_presence_of :public_key, :private_key
  validates_uniqueness_of :public_key

  def initialize_defaults
    if new_record? and self.public_key.nil?
      #TODO: actually generate a pair (iteration 3)
      self.public_key = rand
      self.private_key = rand
    end
  end

  def self.decrypt_password(encrypted_password, public_key)
    #TODO: implement this (iteration 3)
    raise NotImplementedError
  end

end

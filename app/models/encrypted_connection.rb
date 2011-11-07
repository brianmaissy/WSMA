require 'openssl'

class EncryptedConnection < ActiveRecord::Base

  after_initialize :initialize_defaults
  
  validates_presence_of :public_key, :private_key
  validates_uniqueness_of :public_key

  def initialize_defaults
    if new_record? and self.public_key.nil?
      while invalid?
        key = OpenSSL::PKey::RSA.generate( 1024 )
        self.public_key = key.public_key.to_pem
        self.private_key = key.to_pem
      end
    end
  end

  def decrypt(encrypted_password)
    private = OpenSSL::PKey::RSA.new(private_key)
    return private.private_decrypt hex2bin(encrypted_password)
  end

  def hex2bin(hex)
    s = hex
    raise "Not a valid hex string" unless(s =~ /^[\da-fA-F]+$/)
    s = '0' + s if((s.length & 1) != 0)
    return s.scan(/../).map{ |b| b.to_i(16) }.pack('C*')
  end

end

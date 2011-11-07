require 'test_helper'

class EncryptedConnectionTest < ActiveSupport::TestCase

  def setup
    @ec = EncryptedConnection.create
  end

  test "public key must be unique" do
    connection = EncryptedConnection.new(@ec.attributes)
    test_attribute_must_be_unique(connection, :public_key)
  end

  test "set defaults works" do
    connection = EncryptedConnection.new
    assert connection.valid?
  end
  
  test "does not change by finding it" do
    assert_equal @ec, EncryptedConnection.find_by_public_key(@ec.public_key)
  end
  
  test "public and private key pair work properly" do
    private = OpenSSL::PKey::RSA.new(@ec.private_key)
    public = OpenSSL::PKey::RSA.new(@ec.public_key)
    plainText = "thisIsATest"
    cipherText = public.public_encrypt plainText
    assert_not_equal(plainText, cipherText)
    assert_equal(plainText, private.private_decrypt(cipherText))
  end

end

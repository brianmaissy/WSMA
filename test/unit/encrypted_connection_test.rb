require 'test_helper'

class EncryptedConnectionTest < ActiveSupport::TestCase
  test "encrypted_connection_set_defaults_works" do
    @connection = EncryptedConnection.new
    assert @connection.valid?
  end
  
  test "encrypted_connection_does_not_change_by_finding_it" do
    @connection = encrypted_connections(:one)
    assert @connection == EncryptedConnection.find_by_public_key(@connection.public_key)
  end
end

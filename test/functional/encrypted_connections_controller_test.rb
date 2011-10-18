require 'test_helper'

class EncryptedConnectionsControllerTest < ActionController::TestCase
  setup do
    @encrypted_connection = encrypted_connections(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:encrypted_connections)
  end

  test "should create encrypted_connection" do
    assert_difference('EncryptedConnection.count', 1) do
      get :new, :encrypted_connection => @encrypted_connection.attributes
    end

    assert_redirected_to encrypted_connections_path
  end

  test "should destroy encrypted_connection" do
    assert_difference('EncryptedConnection.count', -1) do
      delete :destroy, :id => @encrypted_connection.to_param
    end

    assert_redirected_to encrypted_connections_path
  end
end

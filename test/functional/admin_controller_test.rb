require 'test_helper'

class AdminControllerTest < ActionController::TestCase

  setup do
    @house = House.create(:name => "testHouse")
    @user = User.new(:name => "testUser", :email => "testEmail", :house => @house, :access_level => 3)
    @user.password = "testPassword"
    @user.save!
    old_controller = @controller
    @controller = UsersController.new
    post :login, :email => "testEmail", :password => "testPassword"
    @controller = old_controller
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end

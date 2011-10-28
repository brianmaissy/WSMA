require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @house = House.create(:name => "testHouse")
    @user = User.new(:name => "testUser", :email => "testEmail", :house => @house, :access_level => 3)
    @user.password = "testPassword"
    @user.save!
    post :login, :email => "testEmail", :password => "testPassword"
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      @user = User.new(:name => "testUser1", :email => "unique", :house => @house, :access_level => 1)
      post :create, :user => @user.attributes, :password => "testPassword"
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, :id => @user.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user.to_param
    assert_response :success
  end

  test "should update user" do
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user.to_param
    end

    assert_redirected_to users_path
  end

  test "should be able to access your own profile" do
    get :logout
    user = User.new(:name => "testUser2", :email => "testEmail2", :house => @house, :access_level => 1)
    user.password = "testPassword"
    user.save!
    post :login, :email => "testEmail2", :password => "testPassword"
    get :show, :id => user.to_param
    assert_response :success
  end

  test "should not be able to access someone else\'s profile" do
    get :logout
    user = User.new(:name => "testUser2", :email => "testEmail2", :house => @house, :access_level => 1)
    user.password = "testPassword"
    user.save!
    post :login, :email => "testEmail2", :password => "testPassword"
    get :show, :id => @user.to_param
    assert_redirected_to :action => "show", :id => user.to_param
  end

  test "logout should redirect to login" do
    get :logout
    assert_redirected_to :action => "login"
  end

  test "should not be able to access profile when logged out" do
    get :logout
    get :show, :id => @user.to_param
    assert_redirected_to :action => "login"
  end
end

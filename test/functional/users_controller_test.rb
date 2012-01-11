require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @house = House.create(:name => "testHouse")
    @user = User.new(:name => "testUser", :email => "testEmail@fake.fake", :house => @house, :access_level => 3)
    @user.password = "testPassword"
    @user.save!
    post :login, :email => "testEmail@fake.fake", :password => "testPassword"
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
      @user = User.new(:name => "testUser1", :email => "unique@fake.fake", :house => @house, :access_level => 1)
      post :create, :user => @user.attributes, :password => "testPassword"
    end

    assert_redirected_to users_path
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
    assert_redirected_to users_path
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user.to_param
    end

    assert_redirected_to users_path
  end

  test "should be able to access your own profile" do
    get :logout
    user = User.new(:name => "testUser2", :email => "testEmail2@fake.fake", :house => @house, :access_level => 1)
    user.password = "testPassword"
    user.save!
    post :login, :email => "testEmail2@fake.fake", :password => "testPassword"
    get :show, :id => user.to_param
    assert_response :success
  end

  test "should not be able to access someone else's profile" do
    get :logout
    user = User.new(:name => "testUser2", :email => "testEmail2@fake.fake", :house => @house, :access_level => 1)
    user.password = "testPassword"
    user.save!
    post :login, :email => "testEmail2@fake.fake", :password => "testPassword"
    get :profile, :id => @user.to_param
    assert_redirected_to :action => "profile", :id => user.to_param
  end

  test "should not be able to access admin area when logged in as user" do
    get :logout
    user = User.new(:name => "testUser2", :email => "testEmail2@fake.fake", :house => @house, :access_level => 1)
    user.password = "testPassword"
    user.save!
    post :login, :email => "testEmail2@fake.fake", :password => "testPassword"
    get :index
    assert_redirected_to :action => "login"
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

  test "changing password" do
    get :logout
    user = User.new(:name => "testUser2", :email => "testEmail2@fake.fake", :house => @house, :access_level => 1)
    user.password = "testPassword"
    user.save!
    post :login, :email => "testEmail2@fake.fake", :password => "testPassword"
    post :change_password, :id => user.to_param, :current_password => 'wrong', :new_password => 'new', :confirm_new_password => 'new'
    get :logout
    post :login, :email => "testEmail2@fake.fake", :password => "testPassword"
    assert_redirected_to :action => :profile, :id => user.to_param

    post :change_password, :id => user.to_param, :current_password => 'testPassword', :new_password => 'new', :confirm_new_password => 'different'
    get :logout
    post :login, :email => "testEmail2@fake.fake", :password => "testPassword"
    assert_redirected_to :action => :profile, :id => user.to_param

    post :change_password, :id => user.to_param, :current_password => 'testPassword', :new_password => '', :confirm_new_password => ''
    get :logout
    post :login, :email => "testEmail2@fake.fake", :password => "testPassword"
    assert_redirected_to :action => :profile, :id => user.to_param

    post :change_password, :id => user.to_param, :current_password => 'testPassword', :new_password => 'new', :confirm_new_password => 'new'
    get :logout
    post :login, :email => "testEmail2@fake.fake", :password => "new"
    assert_redirected_to :action => :profile, :id => user.to_param
  end

  test "resetting password" do
    get :logout
    user = User.new(:name => "testUser2", :email => "testEmail2@fake.fake", :house => @house, :access_level => 1)
    user.password = "testPassword"
    user.save!

    post :forgot_password, :email => "testEmail2@fake.fake"
    user.reload

    post :reset_password, :id => user.to_param, :password_reset_token => 'wrong', :new_password => 'new', :confirm_new_password => 'new'
    post :login, :email => "testEmail2@fake.fake", :password => "testPassword"
    assert_redirected_to :action => :profile, :id => user.to_param

    post :reset_password, :id => user.to_param, :password_reset_token => user.password_reset_token, :new_password => 'new', :confirm_new_password => 'different'
    post :login, :email => "testEmail2@fake.fake", :password => "testPassword"
    assert_redirected_to :action => :profile, :id => user.to_param

    post :reset_password, :id => user.to_param, :password_reset_token => user.password_reset_token, :new_password => '', :confirm_new_password => ''
    post :login, :email => "testEmail2@fake.fake", :password => "testPassword"
    assert_redirected_to :action => :profile, :id => user.to_param

    TimeProvider.advance_mock_time(25.hours)
    post :reset_password, :id => user.to_param, :password_reset_token => user.password_reset_token, :new_password => 'new', :confirm_new_password => 'new'
    post :login, :email => "testEmail2@fake.fake", :password => "testPassword"
    assert_redirected_to :action => :profile, :id => user.to_param

    TimeProvider.advance_mock_time(-25.hours)
    post :reset_password, :id => user.to_param, :password_reset_token => user.password_reset_token, :new_password => 'new', :confirm_new_password => 'new'
    post :login, :email => "testEmail2@fake.fake", :password => "new"
    assert_redirected_to :action => :profile, :id => user.to_param

    post :reset_password, :id => user.to_param, :password_reset_token => user.password_reset_token, :new_password => 'newer', :confirm_new_password => 'newer'
    post :login, :email => "testEmail2@fake.fake", :password => "new"
    assert_redirected_to :action => :profile, :id => user.to_param
  end

  def teardown
    TimeProvider.unschedule_all_tasks
  end

end

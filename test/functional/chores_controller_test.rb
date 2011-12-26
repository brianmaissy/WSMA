require 'test_helper'

class ChoresControllerTest < ActionController::TestCase
  setup do
    @house = House.create(:name => "testHouse")
    @user = User.new(:name => "testUser", :email => "testEmail@fake.fake", :house => @house, :access_level => 3)
    @user.password = "testPassword"
    @user.save!
    old_controller = @controller
    @controller = UsersController.new
    post :login, :email => "testEmail@fake.fake", :password => "testPassword"
    @controller = old_controller
    @chore = chores(:one)
    @request.env['HTTP_REFERER'] = 'http://test.host/createChore'
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:chores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create chore" do
    assert_difference('Chore.count') do
      post :create, :chore => @chore.attributes
    end

    assert_redirected_to '/createChore'
  end

  test "should show chore" do
    get :show, :id => @chore.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @chore.to_param
    assert_response :success
  end

  test "should update chore" do
    put :update, :id => @chore.to_param, :chore => @chore.attributes
    assert_redirected_to '/createChore'
  end

  test "should destroy chore" do
    assert_difference('Chore.count', -1) do
      delete :destroy, :id => @chore.to_param
    end

    assert_redirected_to '/createChore'
  end
end

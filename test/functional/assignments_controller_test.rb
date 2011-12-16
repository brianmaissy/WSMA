require 'test_helper'

class AssignmentsControllerTest < ActionController::TestCase
  setup do
    @assignment = assignments(:one)
    @assignment.week = 10
    @house = House.create(:name => "testHouse")
    @user = User.new(:name => "testUser", :email => "testEmail@fake.fake", :house => @house, :access_level => 3)
    @user.password = "testPassword"
    @user.save!
    old_controller = @controller
    @controller = UsersController.new
    post :login, :email => "testEmail@fake.fake", :password => "testPassword"
    @controller = old_controller
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assignments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assignment" do
    assert_difference('Assignment.count') do
      post :create, :assignment => @assignment.attributes
    end

    assert_redirected_to assignment_path(assigns(:assignment))
  end

  test "should show assignment" do
    get :show, :id => @assignment.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @assignment.to_param
    assert_response :success
  end

  test "should update assignment" do
    put :update, :id => @assignment.to_param, :assignment => @assignment.attributes
    assert_redirected_to assignment_path(assigns(:assignment))
  end

  test "should destroy assignment" do
    assert_difference('Assignment.count', -1) do
      delete :destroy, :id => @assignment.to_param
    end

    assert_redirected_to assignments_path
  end

  def teardown
    TimeProvider.unschedule_all_tasks
  end

end

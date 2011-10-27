require 'test_helper'

class UserHourRequirementsControllerTest < ActionController::TestCase
  setup do
    @house = House.create(:name => "testHouse")
    @user = User.create(:name => "testUser", :email => "testEmail", :hashed_password => "xxxx", :salt => "xxxx", :house => @house, :access_level => 1)
    @user_hour_requirement = UserHourRequirement.create(:user => @user, :week => 1, :hours => 5)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_hour_requirements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_hour_requirement" do
    assert_difference('UserHourRequirement.count') do
      @user_hour_requirement.week = 2
      post :create, :user_hour_requirement => @user_hour_requirement.attributes
    end

    assert_redirected_to user_hour_requirement_path(assigns(:user_hour_requirement))
  end

  test "should show user_hour_requirement" do
    get :show, :id => @user_hour_requirement.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user_hour_requirement.to_param
    assert_response :success
  end

  test "should update user_hour_requirement" do
    put :update, :id => @user_hour_requirement.to_param, :user_hour_requirement => @user_hour_requirement.attributes
    assert_redirected_to user_hour_requirement_path(assigns(:user_hour_requirement))
  end

  test "should destroy user_hour_requirement" do
    assert_difference('UserHourRequirement.count', -1) do
      delete :destroy, :id => @user_hour_requirement.to_param
    end

    assert_redirected_to user_hour_requirements_path
  end
end

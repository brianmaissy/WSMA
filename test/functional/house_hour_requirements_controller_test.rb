require 'test_helper'

class HouseHourRequirementsControllerTest < ActionController::TestCase
  setup do
    @house_hour_requirement = house_hour_requirements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:house_hour_requirements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create house_hour_requirement" do
    assert_difference('HouseHourRequirement.count') do
      post :create, :house_hour_requirement => @house_hour_requirement.attributes
    end

    assert_redirected_to house_hour_requirement_path(assigns(:house_hour_requirement))
  end

  test "should show house_hour_requirement" do
    get :show, :id => @house_hour_requirement.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @house_hour_requirement.to_param
    assert_response :success
  end

  test "should update house_hour_requirement" do
    put :update, :id => @house_hour_requirement.to_param, :house_hour_requirement => @house_hour_requirement.attributes
    assert_redirected_to house_hour_requirement_path(assigns(:house_hour_requirement))
  end

  test "should destroy house_hour_requirement" do
    assert_difference('HouseHourRequirement.count', -1) do
      delete :destroy, :id => @house_hour_requirement.to_param
    end

    assert_redirected_to house_hour_requirements_path
  end
end

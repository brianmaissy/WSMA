require 'test_helper'

class HousesControllerTest < ActionController::TestCase
  setup do
    @house = houses(:one)
    @house.name = "unique"
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:houses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create house" do
    assert_difference('House.count') do
      post :create, :house => @house.attributes
    end

    assert_redirected_to house_path(assigns(:house))
  end

  test "should show house" do
    get :show, :id => @house.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @house.to_param
    assert_response :success
  end

  test "should update house" do
    put :update, :id => @house.to_param, :house => @house.attributes
    assert_redirected_to house_path(assigns(:house))
  end

  test "should destroy house" do
    assert_difference('House.count', -1) do
      delete :destroy, :id => @house.to_param
    end

    assert_redirected_to houses_path
  end
end

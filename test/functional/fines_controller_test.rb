require 'test_helper'

class FinesControllerTest < ActionController::TestCase
  setup do
    @fine = fines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fine" do
    assert_difference('Fine.count') do
      post :create, :fine => @fine.attributes
    end

    assert_redirected_to fine_path(assigns(:fine))
  end

  test "should show fine" do
    get :show, :id => @fine.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @fine.to_param
    assert_response :success
  end

  test "should update fine" do
    put :update, :id => @fine.to_param, :fine => @fine.attributes
    assert_redirected_to fine_path(assigns(:fine))
  end

  test "should destroy fine" do
    assert_difference('Fine.count', -1) do
      delete :destroy, :id => @fine.to_param
    end

    assert_redirected_to fines_path
  end
end

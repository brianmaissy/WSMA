require 'test_helper'

class PreferencesControllerTest < ActionController::TestCase
  setup do
    @preference = preferences(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:preferences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create preference" do
    assert_difference('Preference.count') do
      post :create, :preference => @preference.attributes
    end

    assert_redirected_to preference_path(assigns(:preference))
  end

  test "should show preference" do
    get :show, :id => @preference.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @preference.to_param
    assert_response :success
  end

  test "should update preference" do
    put :update, :id => @preference.to_param, :preference => @preference.attributes
    assert_redirected_to preference_path(assigns(:preference))
  end

  test "should destroy preference" do
    assert_difference('Preference.count', -1) do
      delete :destroy, :id => @preference.to_param
    end

    assert_redirected_to preferences_path
  end
end

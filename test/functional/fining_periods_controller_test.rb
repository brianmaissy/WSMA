require 'test_helper'

class FiningPeriodsControllerTest < ActionController::TestCase
  setup do
    @fining_period = fining_periods(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fining_periods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fining_period" do
    assert_difference('FiningPeriod.count') do
      post :create, :fining_period => @fining_period.attributes
    end

    assert_redirected_to fining_period_path(assigns(:fining_period))
  end

  test "should show fining_period" do
    get :show, :id => @fining_period.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @fining_period.to_param
    assert_response :success
  end

  test "should update fining_period" do
    put :update, :id => @fining_period.to_param, :fining_period => @fining_period.attributes
    assert_redirected_to fining_period_path(assigns(:fining_period))
  end

  test "should destroy fining_period" do
    assert_difference('FiningPeriod.count', -1) do
      delete :destroy, :id => @fining_period.to_param
    end

    assert_redirected_to fining_periods_path
  end

  def teardown
    TimeProvider.unschedule_all_tasks
  end
end

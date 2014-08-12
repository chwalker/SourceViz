require 'test_helper'

class WeeklyHistogramsControllerTest < ActionController::TestCase
  setup do
    @weekly_histogram = weekly_histograms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:weekly_histograms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create weekly_histogram" do
    assert_difference('WeeklyHistogram.count') do
      post :create, weekly_histogram: { histogram: @weekly_histogram.histogram, metric: @weekly_histogram.metric, name: @weekly_histogram.name, since_id: @weekly_histogram.since_id, stream: @weekly_histogram.stream, tweet_count: @weekly_histogram.tweet_count }
    end

    assert_redirected_to weekly_histogram_path(assigns(:weekly_histogram))
  end

  test "should show weekly_histogram" do
    get :show, id: @weekly_histogram
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @weekly_histogram
    assert_response :success
  end

  test "should update weekly_histogram" do
    patch :update, id: @weekly_histogram, weekly_histogram: { histogram: @weekly_histogram.histogram, metric: @weekly_histogram.metric, name: @weekly_histogram.name, since_id: @weekly_histogram.since_id, stream: @weekly_histogram.stream, tweet_count: @weekly_histogram.tweet_count }
    assert_redirected_to weekly_histogram_path(assigns(:weekly_histogram))
  end

  test "should destroy weekly_histogram" do
    assert_difference('WeeklyHistogram.count', -1) do
      delete :destroy, id: @weekly_histogram
    end

    assert_redirected_to weekly_histograms_path
  end
end

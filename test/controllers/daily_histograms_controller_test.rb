require 'test_helper'

class DailyHistogramsControllerTest < ActionController::TestCase
  setup do
    @daily_histogram = daily_histograms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:daily_histograms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create daily_histogram" do
    assert_difference('DailyHistogram.count') do
      post :create, daily_histogram: { histogram: @daily_histogram.histogram, metric: @daily_histogram.metric, name: @daily_histogram.name, since_id: @daily_histogram.since_id, stream: @daily_histogram.stream, tweet_count: @daily_histogram.tweet_count }
    end

    assert_redirected_to daily_histogram_path(assigns(:daily_histogram))
  end

  test "should show daily_histogram" do
    get :show, id: @daily_histogram
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @daily_histogram
    assert_response :success
  end

  test "should update daily_histogram" do
    patch :update, id: @daily_histogram, daily_histogram: { histogram: @daily_histogram.histogram, metric: @daily_histogram.metric, name: @daily_histogram.name, since_id: @daily_histogram.since_id, stream: @daily_histogram.stream, tweet_count: @daily_histogram.tweet_count }
    assert_redirected_to daily_histogram_path(assigns(:daily_histogram))
  end

  test "should destroy daily_histogram" do
    assert_difference('DailyHistogram.count', -1) do
      delete :destroy, id: @daily_histogram
    end

    assert_redirected_to daily_histograms_path
  end
end

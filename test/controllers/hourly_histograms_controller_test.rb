require 'test_helper'

class HourlyHistogramsControllerTest < ActionController::TestCase
  setup do
    @hourly_histogram = hourly_histograms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hourly_histograms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hourly_histogram" do
    assert_difference('HourlyHistogram.count') do
      post :create, hourly_histogram: { histogram: @hourly_histogram.histogram, metric: @hourly_histogram.metric, name: @hourly_histogram.name, since_id: @hourly_histogram.since_id, stream: @hourly_histogram.stream, tweet_count: @hourly_histogram.tweet_count }
    end

    assert_redirected_to hourly_histogram_path(assigns(:hourly_histogram))
  end

  test "should show hourly_histogram" do
    get :show, id: @hourly_histogram
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hourly_histogram
    assert_response :success
  end

  test "should update hourly_histogram" do
    patch :update, id: @hourly_histogram, hourly_histogram: { histogram: @hourly_histogram.histogram, metric: @hourly_histogram.metric, name: @hourly_histogram.name, since_id: @hourly_histogram.since_id, stream: @hourly_histogram.stream, tweet_count: @hourly_histogram.tweet_count }
    assert_redirected_to hourly_histogram_path(assigns(:hourly_histogram))
  end

  test "should destroy hourly_histogram" do
    assert_difference('HourlyHistogram.count', -1) do
      delete :destroy, id: @hourly_histogram
    end

    assert_redirected_to hourly_histograms_path
  end
end

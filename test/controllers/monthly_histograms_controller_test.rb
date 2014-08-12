require 'test_helper'

class MonthlyHistogramsControllerTest < ActionController::TestCase
  setup do
    @monthly_histogram = monthly_histograms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:monthly_histograms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create monthly_histogram" do
    assert_difference('MonthlyHistogram.count') do
      post :create, monthly_histogram: { histogram: @monthly_histogram.histogram, metric: @monthly_histogram.metric, name: @monthly_histogram.name, since_id: @monthly_histogram.since_id, stream: @monthly_histogram.stream, tweet_count: @monthly_histogram.tweet_count }
    end

    assert_redirected_to monthly_histogram_path(assigns(:monthly_histogram))
  end

  test "should show monthly_histogram" do
    get :show, id: @monthly_histogram
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @monthly_histogram
    assert_response :success
  end

  test "should update monthly_histogram" do
    patch :update, id: @monthly_histogram, monthly_histogram: { histogram: @monthly_histogram.histogram, metric: @monthly_histogram.metric, name: @monthly_histogram.name, since_id: @monthly_histogram.since_id, stream: @monthly_histogram.stream, tweet_count: @monthly_histogram.tweet_count }
    assert_redirected_to monthly_histogram_path(assigns(:monthly_histogram))
  end

  test "should destroy monthly_histogram" do
    assert_difference('MonthlyHistogram.count', -1) do
      delete :destroy, id: @monthly_histogram
    end

    assert_redirected_to monthly_histograms_path
  end
end

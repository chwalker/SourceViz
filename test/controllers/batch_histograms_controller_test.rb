require 'test_helper'

class BatchHistogramsControllerTest < ActionController::TestCase
  setup do
    @batch_histogram = batch_histograms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:batch_histograms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create batch_histogram" do
    assert_difference('BatchHistogram.count') do
      post :create, batch_histogram: { histogram: @batch_histogram.histogram, metric: @batch_histogram.metric, name: @batch_histogram.name, since_id: @batch_histogram.since_id, tweet_count: @batch_histogram.tweet_count }
    end

    assert_redirected_to batch_histogram_path(assigns(:batch_histogram))
  end

  test "should show batch_histogram" do
    get :show, id: @batch_histogram
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @batch_histogram
    assert_response :success
  end

  test "should update batch_histogram" do
    patch :update, id: @batch_histogram, batch_histogram: { histogram: @batch_histogram.histogram, metric: @batch_histogram.metric, name: @batch_histogram.name, since_id: @batch_histogram.since_id, tweet_count: @batch_histogram.tweet_count }
    assert_redirected_to batch_histogram_path(assigns(:batch_histogram))
  end

  test "should destroy batch_histogram" do
    assert_difference('BatchHistogram.count', -1) do
      delete :destroy, id: @batch_histogram
    end

    assert_redirected_to batch_histograms_path
  end
end

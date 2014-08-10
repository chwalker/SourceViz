json.array!(@batch_histograms) do |batch_histogram|
  json.extract! batch_histogram, :id, :name, :tweet_count, :since_id, :histogram
  json.url batch_histogram_url(batch_histogram, format: :json)
end

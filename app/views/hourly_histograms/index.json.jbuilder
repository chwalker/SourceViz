json.array!(@hourly_histograms) do |hourly_histogram|
  json.extract! hourly_histogram, :id, :name, :tweet_count, :since_id, :histogram, :metric, :stream
  json.url hourly_histogram_url(hourly_histogram, format: :json)
end

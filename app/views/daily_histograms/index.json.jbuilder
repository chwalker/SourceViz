json.array!(@daily_histograms) do |daily_histogram|
  json.extract! daily_histogram, :id, :name, :tweet_count, :since_id, :histogram, :metric, :stream
  json.url daily_histogram_url(daily_histogram, format: :json)
end

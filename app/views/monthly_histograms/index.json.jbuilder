json.array!(@monthly_histograms) do |monthly_histogram|
  json.extract! monthly_histogram, :id, :name, :tweet_count, :since_id, :histogram, :metric, :stream
  json.url monthly_histogram_url(monthly_histogram, format: :json)
end

json.array!(@weekly_histograms) do |weekly_histogram|
  json.extract! weekly_histogram, :id, :name, :tweet_count, :since_id, :histogram, :metric, :stream
  json.url weekly_histogram_url(weekly_histogram, format: :json)
end

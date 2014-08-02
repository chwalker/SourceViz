json.array!(@twitter_users) do |twitter_user|
  json.extract! twitter_user, :id, :name, :handle, :stats, :profile, :twitter_id, :topics
  json.url twitter_user_url(twitter_user, format: :json)
end

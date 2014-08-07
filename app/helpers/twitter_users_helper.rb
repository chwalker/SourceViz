
module TwitterUsersHelper

  def prepare_access_token(oauth_token, oauth_token_secret)
    consumer = OAuth::Consumer.new( ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET'],
                                    :site => "https://api.twitter.com", :scheme => :header)
    token_hash = { :oauth_token => oauth_token,:oauth_token_secret => oauth_token_secret }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
    return access_token
  end

  def get_friends_list(user_name=@twitter_user[:handle], access_token=nil, cursor=-1)
    token ||= prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
    url = "https://api.twitter.com/1.1/friends/ids.json?cursor=#{cursor}&screen_name=#{user_name}&count=5000.json"
    response = token.request(:get, url)
    JSON.parse(response.body, symbolize_names: true)
  end

end

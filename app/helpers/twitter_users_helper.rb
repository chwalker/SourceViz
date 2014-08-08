
module TwitterUsersHelper

  def get_friends_list(user_name=@twitter_user[:handle], access_token=nil, cursor=-1)
    token ||= prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
    url = "https://api.twitter.com/1.1/friends/ids.json?cursor=#{cursor}&screen_name=#{user_name}&count=5000.json"
    response = token.request(:get, url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def get_profile(handle='TheLoki47', access_token=nil)
    token ||= prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
    response = token.request(:get, "https://api.twitter.com/1.1/users/show.json?screen_name=#{handle}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def refresh_user_profile(user, friend=false)
    begin
      twitter_user = TwitterUser.find(user[:id])
      twitter_user.merge!( json_content(user) )
    rescue => err
      twitter_user = TwitterUser.new( json_content(user, true, friend) )
    end
    
    warn "ERROR: Failed to save: #{twitter_user.to_json}\n\n" unless twitter_user.save
  end
  
  def json_content(json, create=false, friend=false)
    if create
      {
        id:         json[:id],
        name:       json[:name],
        handle:     json[:screen_name],
        profile:    json.to_json,
        topics:     { lists: [ ], slugs: [ ] }.to_json,
        stats:      { }.to_json,
        is_friends: friend
      }
    else
      {
        id:         json[:id],
        name:       json[:name],
        handle:     json[:screen_name],
        profile:    json.to_json,
      }
    end
  end
  
end

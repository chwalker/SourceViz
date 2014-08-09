
module TwitterUsersHelper

  def api_url( )
    "https://api.twitter.com/1.1"
  end

  def get_friends_list(user_name=@twitter_user[:handle], token=nil, cursor=-1)
    token ||= prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
    url = "#{api_url}/friends/ids.json?cursor=#{cursor}&screen_name=#{user_name}&count=5000.json"
    response = token.request(:get, url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def get_profile(handle='TheLoki47', token=nil)
    token ||= prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
    response = token.request(:get, "#{api_url}/users/show.json?screen_name=#{handle}")
    JSON.parse(response.body, symbolize_names: true)
  end
  
  def set_friend_status(user=@twitter_user, method=:create, token=nil)
    token ||= prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
    url = "#{api_url}/friendships/#{method}.json?screen_name=#{user[:handle]}"
    response = token.request(:post, url)
    puts [url, response].inspect
    JSON.parse(response.body, symbolize_names: true)
  end
  
  def update_friend_status(user=@twitter_user, method=:create)
    set_friend_status(user, method)
    user[:is_friends] = true  if method == :create
    user[:is_friends] = false if method == :destroy
    warn "ERROR: Failed to save: #{user.to_json}\n\n" unless user.save
  end
  
  def update_profile_by_name(handle='TheLoki47', friend=false)
    refresh_user_profile(get_profile(handle), friend)
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

  def find_or_make(profile)
    begin
      TwitterUser.find(profile[:id])
    rescue => err
      warn "Making new user (#{profile[:screen_name]}) ..."
      TwitterUser.new(json_content(profile, true))
    end
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

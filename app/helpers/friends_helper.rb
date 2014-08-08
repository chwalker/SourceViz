module FriendsHelper

  include TwitterUsersHelper
  
  def friends_url(cursor=-1)
    "https://api.twitter.com/1.1/friends/list.json?cursor=#{cursor}&count=200"
  end

  def update_all_friends()
    access_token = prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
    cursor  = -1
    while cursor != 0
      response = access_token.request(:get, friends_url(cursor) )
      json = JSON.parse(response.body, symbolize_names: true)
      cursor = json[:next_cursor]
      json[:users].each {|user| refresh_user_profile(user, true) }
      $stderr << '.'
      sleep(60)
    end
  end
  
end

#!/usr/bin/env ruby

require 'date'
require 'oauth'
require 'json'

def prepare_access_token(oauth_token, oauth_token_secret)
  consumer = OAuth::Consumer.new( ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET'],
                                  :site => "https://api.twitter.com", :scheme => :header)
  token_hash = { :oauth_token => oauth_token,:oauth_token_secret => oauth_token_secret }
  access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
  return access_token
end

def friends_sublist(cursor)
  "https://api.twitter.com/1.1/friends/list.json?cursor=#{cursor}&count=200"
end

def update_friend_entry(json)
  twitter_user = TwitterUser.where( twitter_id: json[:id] ).first
  
  update = {
    twitter_id: json[:id],
    name:       json[:name],
    handle:     json[:screen_name],
    stats:      { }.to_json,
    lists:      { }.to_json,
    topics:     { }.to_json,
    profile:    json.to_json,
    is_friends: true
  }
  
  if twitter_user
    twitter_user.merge!(update) ## NB: this will overwrite stats, topics and lists
  else
    twitter_user = TwitterUser.new(update)
  end
  
  warn "ERROR: Failed to save: #{twitter_user.to_json}\n\n" unless twitter_user.save
end

def update_all_friends(access_token=nil)
  access_token ||= prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
  cursor  = -1
  friends = [ ]
  while cursor != 0
    response = access_token.request(:get, friends_sublist(cursor) )
    json   = JSON.parse(response.body, symbolize_names: true)
    cursor = json[:next_cursor]
    json[:users].each {|user| update_friend_entry user }
    $stderr << '.'
    sleep(60)
  end
end

# Exchange our oauth_token and oauth_token secret for the AccessToken instance.
update_all_friends( )

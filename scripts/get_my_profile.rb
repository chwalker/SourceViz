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

def get_profile(access_token=nil)
  token ||= prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
  response = token.request(:get, "https://api.twitter.com/1.1/users/show.json?screen_name=theLoki47")
  JSON.parse(response.body, symbolize_names: true)
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
    is_friends: false
  }
  
  if twitter_user
    twitter_user.merge!(update) ## NB: this will overwrite stats, topics and lists
  else
    twitter_user = TwitterUser.new(update)
  end
  
  warn "ERROR: Failed to save: #{twitter_user.to_json}\n\n" unless twitter_user.save
end


# Exchange our oauth_token and oauth_token secret for the AccessToken instance.
profile = get_profile( )
update_friend_entry(profile)

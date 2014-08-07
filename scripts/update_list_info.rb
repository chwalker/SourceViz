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

def list_url()
  "https://api.twitter.com/1.1/lists/list.json"
end

def list_member_url(id=34918716, cursor=-1)
  "https://api.twitter.com/1.1/lists/members.json?list_id=#{id}&cursor=#{cursor}"
end

def get_lists()
  token ||= prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
  response = token.request(:get, list_url() )
  JSON.parse(response.body, symbolize_names: true)
end

def get_list_members(id=34918716, recursive=false)
  token ||= prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
  users  = [ ]
  if recursive
    cursor = -1
    while cursor != 0
      $stderr << '.'
      response = token.request(:get, list_member_url(id, cursor))
      result  = JSON.parse(response.body, symbolize_names: true)
      users  += result[:users]
      cursor  = result[:next_cursor]
    end
  else
    response = token.request(:get, list_member_url(id))
    users += JSON.parse(response.body, symbolize_names: true)[:users]
  end
  $stderr << "\n"
  users
end

def user_json(profile)
  {
    id:         profile[:id],
    name:       profile[:name],
    handle:     profile[:screen_name],
    stats:      { }.to_json,
    lists:      { }.to_json,
    topics:     { }.to_json,
    profile:    profile.to_json,
    is_friends: false
  }
  
end

def update_lists(user, list_name)
  topics = JSON.parse(user[:topics]) rescue { }
  topics[:lists] ||= [ ]
  topics[:lists] << list_name unless topics[:lists].include? list_name
  user[:topics] = topics.to_json

  warn "Failed to save #{user.inspect}" unless user.save
end

## TODO: remove lists ???
def add_list_to_user_topics(profile, list_name)
  
  begin
    user = TwitterUser.find(profile[:id])
  rescue => err
    warn "Making new user (#{profile[:screen_name]}) ..."
    user = TwitterUser.new(user_json(profile))
  end
  
  update_lists(user, list_name)
end

get_lists().each do |list|
  $stderr << "\nGetting #{list[:slug]} (#{list[:id]}) list members"
  get_list_members(list[:id], true).each {|user| add_list_to_user_topics(user, list[:slug]) }
end


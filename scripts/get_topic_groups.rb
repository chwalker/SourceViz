#!/usr/bin/env ruby

require 'date'
require 'oauth'
require 'json'

RELEVANT_TOPICS = %w( music photography funny news technology television business books science government 'social-good'  )

TOPIC_TO_GROUP = {
  music:       :fun,
  photography: :news,
  funny:       :fun,
  news:        :news,
  technology:  :tech,
  television:  :fun,
  business:    :biz,
  books:       :fun,
  science:     :tech,
  government:  :gov,
  socialgood:  :gov
}

def prepare_access_token(oauth_token, oauth_token_secret)
  consumer = OAuth::Consumer.new( ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET'],
                                  :site => "https://api.twitter.com", :scheme => :header)
  token_hash = { :oauth_token => oauth_token,:oauth_token_secret => oauth_token_secret }
  access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
  return access_token
end

def get_group_list(slug='news', access_token=nil)
  token ||= prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
  response = token.request(:get, "https://api.twitter.com/1.1/users/suggestions/#{slug}.json")
  JSON.parse(response.body, symbolize_names: true)
end

def profile_to_user_json(json)
  {
    twitter_id: json[:id],
    name:       json[:name],
    handle:     json[:screen_name],
    stats:      { }.to_json,
    lists:      { }.to_json,
    topics:     { }.to_json,
    profile:    json.to_json,
    is_friends: false
  }
end

def update_user_details( topic, profile )
  user = TwitterUser.where( handle: profile[:screen_name] ).first

  if user.nil?
    puts "Making news user ..."
    user = TwitterUser.new(profile_to_user_json(profile))
  end

  user[:topics] = update_user_topic_hash( topic, user )

  puts user.inspect + "\n"
end

def update_user_topic_hash( topic, user )
  list = JSON.parse(user[:topics]) rescue { }
  list[:topics] ||= [ ]
  list[:topics] << topic unless list[:topics].include? topic
  list.to_json
end

def upload_topic_details(topic)
  json = get_group_list(topic)
  json[:users].each {|profile| update_user_details(topic, profile) }
end


## MAIN PROGRAM LOGIC:
RELEVANT_TOPICS.each do |topic|
  upload_topic_details(topic)
  sleep(60)
end

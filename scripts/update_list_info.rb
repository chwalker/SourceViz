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

def get_list_members(slug='met', recursive=false)
  token ||= prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
  users  = [ ]
  if recursive
    cursor = -1
    while cursor != 0
      $stderr << '.'
      response = token.request(:get, list_member_url(slug, cursor))
      result  = JSON.parse(response.body, symbolize_names: true)
      users  += result[:users]
      cursor  = result[:next_cursor]
    end
  else
    response = token.request(:get, list_member_url(slug))
    users += JSON.parse(response.body, symbolize_names: true)[:users]
  end
  $stderr << "\n"
  users
end

get_lists().each do |list|
  $stderr << "\nGetting #{list[:slug]} (#{list[:id]}) list members"
  get_list_members(list[:id], true).each do |user|
    warn ['', user[:id], user[:screen_name], user[:name] ] * "\t"
  end
end


#!/usr/bin/env ruby

require 'date'
require 'oauth'
require 'json'

include ApplicationHelper
include TweetsHelper

TARGETED_ENTITIES = [ :tokens, :mentions, :hashtags, :symbols, :urls ]

since_id = nil

while(true)
  reduced  = Hash.new {|h,k| h[k] = Hash.new(0) }
  tweets   = get_home_timeline(since_id)
  count    = tweets.size
  since_id = tweets[0][:id]
  tweets.each do |tweet|
    TARGETED_ENTITIES.each do |name|
      reduced[name] = reduce_histograms([ reduced[name], histogram(tweet, name) ]) 
    end
  end
  $stderr << "\n#{count} tweets retrieved"
  save_batch_histograms(reduced, count, since_id)
  sleep(180)
end

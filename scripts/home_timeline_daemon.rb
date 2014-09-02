#!/usr/bin/env ruby

require 'date'
require 'oauth'
require 'json'

include ApplicationHelper
include TweetsHelper

TARGETED_ENTITIES = [ :tokens, :mentions, :hashtags, :symbols, :urls ]
MAX_SLEEP_TIME = 600
MIN_SLEEP_TIME = 90

since_id   = nil
sleep_time = 300

while(true)
  tf = Hash.new {|h,k| h[k] = Hash.new(0) }
  df = Hash.new {|h,k| h[k] = Hash.new(0) }
  
  tweets   = get_home_timeline(since_id)
  count    = tweets.size
  since_id = tweets[0][:id]
  tweets.each do |tweet|
    TARGETED_ENTITIES.each do |name|
      tf_hist  = make_histogram(tweet, name)
      tf[name] = reduce_histograms([ tf[name], tf_hist ]) 

      df_hist  = document_frequency(tf_hist)
      df[name] = reduce_histograms([ df[name], df_hist ]) 
    end
  end
  $stderr << "\n#{count} tweets retrieved at #{DateTime.now}"

  begin
    save_batch_histograms(tf, count, since_id, :term_frequency, :home_timeline)
    save_batch_histograms(df, count, since_id, :document_frequency, :home_timeline)
  rescue => err
    warn "Batch histogram (#{since_id}) failed to save at #{Datetime.now}: #{err}"
  end
  
  if count >= 195 and sleep_time > MIN_SLEEP_TIME
    $stderr << "Adjusting sleep time (Tweets: #{count}, Sleep: #{sleep_time}). Reducing by 30s."
    sleep_time -= 30
  end

  if count < 150 and sleep_time < MAX_SLEEP_TIME
    $stderr << "Adjusting sleep time (Tweets: #{count}, Sleep: #{sleep_time}). Increasing by 30s."
    sleep_time += 30
  end

  sleep(sleep_time)
end

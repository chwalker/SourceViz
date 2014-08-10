
module TweetsHelper

  include TwitterUsersHelper
  
  def get_home_timeline(since_id=nil, token=nil)
    token ||= prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
    url = "#{api_url}/statuses/home_timeline.json?count=200&trim_user=true"
    url += "&since_id=#{since_id}" unless since_id.nil?
    response = token.request(:get, url)
    JSON.parse(response.body, symbolize_names: true)
  end
  
  ### BASIC TEXT PROCESSING:
  def tokenize(string)
    string.gsub(/\shttp\S+\s/,' ').downcase.split(/\W/)
  end
  
  def histogram(tweet, entity_name=:tokens)
    hist = Hash.new(0)
    histogram_tokens(tweet, entity_name).each {|token| hist[token] += 1 unless token !~ /\S/ }
    hist
  end

  def document_frequency(hist)
    df = Hash.new(0)
    hist.keys.each {|token| df[token] = 1 }
    df
  end
  
  def histogram_tokens(tweet, entity_name)
    case entity_name
    when :tokens
      tokenize(tweet[:text])      
    when :mentions
      tweet[:entities][:user_mentions].map{|m| m[:id] }
    when :hashtags
      tweet[:entities][:hashtags].map {|h| h[:text] }
    when :symbols
      tweet[:entities][:symbols]
    when :urls
      tweet[:entities][:urls].map {|u| u[:expanded_url] }
    end
  end
  
  def reduce_histograms( histograms )
    reduced = Hash.new(0)
    histograms.each {|hist| hist.each {|k,v| reduced[k] += v } }
    reduced
  end
  
  def save_batch_histograms(histograms, tweet_count, since_id, metric=:term_frequency)
    histograms.each do |name, hist|
      batch_details = {
        name: name, 
        tweet_count: tweet_count, 
        histogram: hist.to_json,
        since_id: since_id,
        metric: metric
      }
      batch = BatchHistogram.new(batch_details)
      warn "Failed to save batch: #{batch.inspect}" unless batch.save
      $stderr << '.'
    end
  end
  
end

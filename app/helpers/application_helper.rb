module ApplicationHelper

  ####################### API Access Methods ###########################

  def prepare_access_token(oauth_token, oauth_token_secret)
    consumer = OAuth::Consumer.new( ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET'],
                                    :site => "https://api.twitter.com", :scheme => :header)
    token_hash = { :oauth_token => oauth_token,:oauth_token_secret => oauth_token_secret }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
    return access_token
  end

  #################### Graph Management Methods ########################

  def user_profile(user)
    if user[:profile].kind_of? Integer
      user
    else
      JSON.parse( user[:profile], symbolize_names: true)
    end
  end
  
  def node_json( user )
    profile = user_profile(user)
    { 
      name:  screen_name(profile),
      color: node_color(user),
      size:  node_size(profile),
      depth: node_depth(profile),
      strength: edge_strength(profile)
    }
  end
  
  def screen_name(profile)
    if profile.kind_of? Integer
      profile
    else
      profile[:screen_name]
    end
  end
  
  def node_color( user )
    if user[:profile].kind_of? Integer
      '#000000'  ## black for unknown users
    else
      profile = JSON.parse(user[:profile], symbolize_names: true)
      if profile[:verified]
        '#58FAF4'  ## cyan for verified
      else
        topics = JSON.parse(user[:topics], symbolize_names: true)
        if topics[:lists].nil? or topics[:lists].empty?
          '#FBFBEF'  ## pale yellow by default        
        else
          if !( topics[:lists] & [ 'met', 'powerset-posse'] ).empty?
            '#58FA58' ## green
          elsif topics[:lists].include? 'p2'
            '#819FF7' ## blue
          elsif topics[:lists].include? 'tcot'
            '#FA5858' ## red
          elsif !( topics[:lists] & [ 'pundits', 'pollsters'] ).empty?
            '#D358F7' ## purple
          elsif !( topics[:lists] & [ 'big-data', 'sci', 'nerds' ] ).empty?
            '#FACC2E' ## orange
          elsif !( topics[:lists] & [ 'media', 'world', 'nation' ] ).empty?
            '#FE2EC8' ## pink
          elsif topics[:lists].include? 'fun'
            '#BDBDBD' ## greyscale
          else
            '#FBFBEF'  ## pale yellow by default        
          end
        end
      end
    end
  end

  def edge_strength(profile)
    if !profile.kind_of?(Integer) and profile[:followers_count]
      Math.log(profile[:followers_count])
    else
      10
    end
  end
  
  def node_depth( profile )
    if !profile.kind_of?(Integer) and profile[:statuses_count]
      (Math.log(profile[:statuses_count]) / 10)
    else
      4 
    end
  end

  def node_size( profile )
    if !profile.kind_of?(Integer) and profile[:friends_count]
      Math.log(profile[:friends_count])
    else
      6
    end
  end
  
end

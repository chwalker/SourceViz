module ApplicationHelper
  
  def node_json( user )
    profile = JSON.parse( user[:profile], symbolize_names: true)
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
        '#EFFBFB'  ## cyan for verified
      else
        topics = JSON.parse(user[:topics], symbolize_names: true)
        if topics[:lists].nil? or topics[:lists].empty?
          '#FBFBEF'  ## pale yellow by default        
        else
          if !( topics[:lists] & [ 'met', 'powerset-posse'] ).empty?
            '#58FA58' ## green
          elsif topics[:lists].include? 'p2'
            '#5858FA' ## blue
          elsif topics[:lists].include? 'tcot'
            '#FE2E2E' ## red
          elsif !( topics[:lists] & [ 'pundits', 'pollsters'] ).empty?
            '#D358F7' ## purple
          elsif !( topics[:lists] & [ 'big-data', 'sci' ] ).empty?
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

  def edge_strength( profile )
    if !profile.kind_of?(Integer) 
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
      10
    end
  end
  
end

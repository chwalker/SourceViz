module ApplicationHelper

  def node_json( profile )
    { 
      name:  screen_name(profile),
      color: node_color(profile), 
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
  
  def node_color( user_profile )
    if user_profile.kind_of? Integer
      '#000000'  ## black for unknown users
    elsif user_profile[:verified]
      '#EFFBFB'  ## cyan for verified
    else
      '#FBFBEF'  ## yellow by default
    end
  end

  def edge_strength( user_profile )
    if !user_profile.kind_of?(Integer) and user_profile[:followers_count]
      Math.log(user_profile[:followers_count])
    else
      10
    end
  end
  
  def node_depth( user_profile )
    if !user_profile.kind_of?(Integer) and user_profile[:statuses_count]
      (Math.log(user_profile[:statuses_count]) / 10)
    else
      4 
    end
  end

  def node_size( user_profile )
    if !user_profile.kind_of?(Integer) and user_profile[:friends_count]
      Math.log(user_profile[:friends_count])
    else
      2
    end
  end
  
end

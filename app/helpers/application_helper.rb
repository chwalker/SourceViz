module ApplicationHelper

  def node_color( user_profile )

    if user_profile.nil?    
      '#000000'  ## black for unknown users
    elsif user_profile[:verified]
      '#EFFBFB'  ## cyan for verified
    else
      '#FBFBEF'  ## yellow by default
    end
  end

  def edge_strength( user_profile )
    if !user_profile.nil? and user_profile[:followers_count]
      Math.log(user_profile[:followers_count])
    else
      10
    end
  end
  
  def node_depth( user_profile )
    if !user_profile.nil? and user_profile[:statuses_count]
      (Math.log(user_profile[:statuses_count]) / 10)
    else
      4 
    end
  end

  def node_size( user_profile )
    if !user_profile.nil? and user_profile[:friends_count]
      Math.log(user_profile[:friends_count])
    else
      2
    end
  end
  
end

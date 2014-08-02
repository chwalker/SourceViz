module FriendsHelper
  
  def node_color( user_profile )

    if user_profile.nil?    
      '#000000'  ## black for new users
    elsif user_profile[:verified]
      '#EFFBFB'  ## cyan for verified
    else
      '#FBFBEF'  ## yellow by default
    end
  end

  def edge_strength( user_profile )
    Math.log(user_profile[:followers_count])
  end

  def node_depth( user_profile )
    (Math.log(user_profile[:statuses_count]) / 10)
  end

  def node_size( user_profile )
    Math.log(user_profile[:friends_count])
  end

end

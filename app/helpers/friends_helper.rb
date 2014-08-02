module FriendsHelper
  
  def node_color( user_profile )
    color = '#FBFBEF'                               ## yellow by default
    color = '#000000' if user_profile.nil?          ## black for new users

    color = '#EFFBFB' if user_profile[:verified]    ## cyan for verified
    color
  end

  def edge_strength( user_profile )
    (Math.log(user_profile[:followers_count]))
  end

  def node_depth( user_profile )
    (Math.log(user_profile[:statuses_count]) / 10)
  end

  def node_size( user_profile )
    Math.log(user_profile[:friends_count])
  end

end

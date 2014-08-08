module ListsHelper

  include TwitterUsersHelper

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
  
  def get_list_members(id=34918716, recursive=false)
    token ||= prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
    users  = [ ]
    if recursive
      cursor = -1
      while cursor != 0
        $stderr << '.'
        response = token.request(:get, list_member_url(id, cursor))
        result  = JSON.parse(response.body, symbolize_names: true)
        users  += result[:users]
        cursor  = result[:next_cursor]
      end
    else
      response = token.request(:get, list_member_url(id))
      users += JSON.parse(response.body, symbolize_names: true)[:users]
    end
    $stderr << "\n"
  users
  end

  def update_all_lists( )
    get_lists().each do |list|
      $stderr << "\nGetting #{list[:slug]} (#{list[:id]}) list members"
      get_list_members(list[:id], true).each {|user| add_list_to_user(user, list[:slug]) }
    end
  end

  ## TODO: more abstract as generic json attr updater
  def update_user_lists(user, list_name)
    topics = JSON.parse(user[:topics], symbolize_names: true) rescue { }
    topics[:lists] ||= [ ]
    topics[:lists] << list_name unless topics[:lists].include? list_name
    user[:topics] = topics.to_json
    warn "Failed to save #{user.inspect}" unless user.save
  end
  
  ## TODO: remove lists ???
  def add_list_to_user(profile, list_name)
    user = find_or_make(profile)
    update_user_lists(user, list_name)
  end
  
end

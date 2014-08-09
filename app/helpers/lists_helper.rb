module ListsHelper

  include TwitterUsersHelper

  def list_url()
    "#{api_url}/lists/list.json"
  end
  
  def list_member_url(id=34918716, cursor=-1)
    "#{api_url}/lists/members.json?list_id=#{id}&cursor=#{cursor}"
  end
  
  def list_update_url(method=:create)
    "#{api_url}/lists/members/#{method}.json"
  end
  
  def list_update_params(handle, slug, owner='TheLoki47')
    "slug=#{slug}&owner_screen_name=#{owner}&screen_name=#{handle}"
  end
  
  def get_lists()
    token ||= prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
    response = token.request(:get, list_url() )
    JSON.parse(response.body, symbolize_names: true)
  end
  
  def post_to_list(handle, slug, method)
    url = [ list_update_url(method), list_update_params(handle, slug) ] * "?"
    token ||= prepare_access_token(ENV['TWITTER_AUTH_TOKEN'], ENV['TWITTER_AUTH_SECRET'])
    response = token.request(:post, url) 
    puts [ url, response.inspect ] * ' '
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
  def update_user_lists(user, list_name, method=:add)
    topics = JSON.parse(user[:topics], symbolize_names: true) rescue { }
    topics[:lists] ||= [ ]
    if method == :add
      topics[:lists] << list_name unless topics[:lists].include? list_name
    elsif method == :remove
      topics[:lists].delete(list_name)
    end
    user[:topics] = topics.to_json
    warn "Failed to save #{user.inspect}" unless user.save
  end
  
  def add_list_to_user(profile, list_name)
    user = find_or_make(profile)
    update_user_lists(user, list_name, :add)
  end

  def remove_list_from_user(profile, list_name)
    user = find_or_make(profile)
    update_user_lists(user, list_name, :remove)
  end
  
  def add_user_to_list(user, list_name)
    post_to_list(user[:handle], list_name, :create)
  end
  
  def remove_user_from_list(user, list_name)
    post_to_list(user[:handle], list_name, :destroy)
  end
  
end

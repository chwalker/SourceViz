class TwitterUsersController < ApplicationController

  include ApplicationHelper
  include TwitterUsersHelper
  include ListsHelper

  before_action :set_twitter_user, only: [:profile, :graph, :update_list, :downdate_list, :befriend, :defriend]

  # GET /twitter_users
  # GET /twitter_users.json
  def index
    @twitter_users = TwitterUser.all
    @friends = [ ]
    @twitter_users.each do |user|
      profile = JSON.parse(user[:profile], symbolize_names: true)
      size    = Math.log(profile[:friends_count])
      color   = { true => 'fill:cyan', false => 'fill:black' }[profile[:verified]]
      @friends << { handle: user[:handle], x: rand(1000), y: rand(800), r: size, c: color }
    end
    @user = TwitterUser.where( handle: 'BarackObama' ).first
    @profile = JSON.parse(@user[:profile], symbolize_names: true)
  end

  def update_list
    @list_name = params[:list]
    respond_to do |format|
      profile = JSON.parse(@twitter_user[:profile], symbolize_names: true)

      add_list_to_user(profile, @list_name)
      add_user_to_list(@twitter_user, @list_name)
      set_twitter_user( )
      
      format.json do 
        render json: @twitter_user
      end
      
      format.html do
        @topics  = JSON.parse(@twitter_user[:topics],  symbolize_names: true)
        @profile = JSON.parse(@twitter_user[:profile], symbolize_names: true)
        render partial: "profile"
      end

    end
  end
  
  def downdate_list
    @list_name = params[:list]
    respond_to do |format|
      profile = JSON.parse(@twitter_user[:profile], symbolize_names: true)
      
      remove_list_from_user(profile, @list_name)
      remove_user_from_list(@twitter_user, @list_name)
      set_twitter_user( )
      
      format.json do 
        render json: @twitter_user
      end
      
      format.html do
        @topics  = JSON.parse(@twitter_user[:topics],  symbolize_names: true)
        @profile = JSON.parse(@twitter_user[:profile], symbolize_names: true)
        render partial: "profile"
      end

    end
  end

  def befriend
    respond_to do |format|
      update_friend_status(@twitter_user, :create)
      set_twitter_user( )
      
      format.json do 
        render json: @twitter_user
      end
      
      format.html do
        @topics  = JSON.parse(@twitter_user[:topics],  symbolize_names: true)
        @profile = JSON.parse(@twitter_user[:profile], symbolize_names: true)
        render partial: "profile"
      end

    end
  end
  
  def defriend
    respond_to do |format|
      update_friend_status(@twitter_user, :destroy)
      set_twitter_user( )
      
      format.json do 
        render json: @twitter_user
      end
      
      format.html do
        @topics  = JSON.parse(@twitter_user[:topics],  symbolize_names: true)
        @profile = JSON.parse(@twitter_user[:profile], symbolize_names: true)
        render partial: "profile"
      end
      
    end
  end
  
  def profile
    respond_to do |format|
      @profile = JSON.parse(@twitter_user[:profile], symbolize_names: true)
      format.json do 
        render json: @profile
      end

      format.html do
        @topics = JSON.parse(@twitter_user[:topics], symbolize_names: true)
        render partial: "profile"
      end
    end
  end
  
  def graph
    @profile   = JSON.parse(@twitter_user[:profile], symbolize_names: true)
    response   = get_friends_list(@twitter_user[:handle])

    @friends   = response[:ids]
    @svg_nodes = [ ]
    @svg_nodes << { name: @twitter_user[:handle], color: 'darkred', size: 10, depth: 1, strength: 0 }
    @friends.each do |user_id|
      user = TwitterUser.find(user_id) rescue { profile: user_id }
      @svg_nodes << node_json(user)
    end
    
    @svg_edges = [ ]
    (1...@svg_nodes.size).each do |i|
      @svg_edges << { source: i, target: 0, value: 1, strength: @svg_nodes[i][:strength] }
    end

    @svg_data = { nodes: @svg_nodes, links: @svg_edges }.to_json
  end
  
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_twitter_user
    @twitter_user = TwitterUser.where( handle: params[:id]).first
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def twitter_user_params
    params.require(:twitter_user).permit(:name, :handle, :stats, :profile, :topics, :list)
  end

end

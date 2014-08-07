class TwitterUsersController < ApplicationController

  include ApplicationHelper
  include TwitterUsersHelper

  before_action :set_twitter_user, only: [:profile, :graph]

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
  
  def profile
    respond_to do |format|
      @profile = JSON.parse(@twitter_user[:profile], symbolize_names: true)
      
      format.json do 
        render json: @profile
      end

      format.html do
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
      begin
        profile = JSON.parse(TwitterUser.find(user_id)[:profile], symbolize_names: true) rescue nil
        @svg_nodes << node_json(profile)
      rescue
        @svg_nodes << node_json(user_id)        
      end
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
    params.require(:twitter_user).permit(:name, :handle, :stats, :profile, :topics)
  end

end

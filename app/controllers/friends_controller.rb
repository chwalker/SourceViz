class FriendsController < ApplicationController

  include FriendsHelper

  def index
    @friends = TwitterUser.where( is_friends: true )
    @user    = TwitterUser.where( handle: 'TheLoki47' ).first
    @profile = JSON.parse(@user[:profile], symbolize_names: true)
    
    @svg_nodes = [ ]
    @svg_nodes << { name: 'TheLoki47', color: 'darkred', size: 4, depth: 1, strength: 0 }
    @friends.each do |user|
      profile = JSON.parse(user[:profile], symbolize_names: true)
      @svg_nodes << { 
        name:  user[:handle], 
        color: node_color(profile), 
        size:  node_size(profile),
        depth: node_depth(profile),
        strength: edge_strength(profile)
      }
    end

    @svg_edges = [ ]
    (1...@svg_nodes.size).each do |i|
      @svg_edges << { source: i, target: 0, value: 1, strength: @svg_nodes[i][:strength] }
    end
    
    @svg_data = { nodes: @svg_nodes, links: @svg_edges }.to_json
  end
end

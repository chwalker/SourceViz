Rails.application.routes.draw do
  get 'friends/index'
  get 'twitter_users/profile/:id' => 'twitter_users#profile'
  get 'twitter_users/graph/:id'   => 'twitter_users#graph'
  get 'twitter_users/lists/:id/:list'   => 'twitter_users#update_list'
end

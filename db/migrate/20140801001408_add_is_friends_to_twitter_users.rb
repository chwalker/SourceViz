class AddListsAndIsFriendsToTwitterUsers < ActiveRecord::Migration
  def change
    add_column :twitter_users, :is_friends, :boolean
  end
end

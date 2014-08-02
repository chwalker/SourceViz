class CreateTwitterUsers < ActiveRecord::Migration
  def change
    create_table :twitter_users do |t|
      t.string :name
      t.string :handle
      t.text :stats
      t.text :profile
      t.integer :twitter_id
      t.text :topics

      t.timestamps
    end
  end
end

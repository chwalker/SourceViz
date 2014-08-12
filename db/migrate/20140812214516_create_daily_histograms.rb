class CreateDailyHistograms < ActiveRecord::Migration
  def change
    create_table :daily_histograms do |t|
      t.string :name
      t.integer :tweet_count
      t.integer :since_id
      t.text :histogram
      t.string :metric
      t.string :stream

      t.timestamps
    end
  end
end

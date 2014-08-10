class CreateBatchHistograms < ActiveRecord::Migration
  def change
    create_table :batch_histograms do |t|
      t.string :name
      t.integer :tweet_count
      t.integer :since_id
      t.text :histogram

      t.timestamps
    end
  end
end

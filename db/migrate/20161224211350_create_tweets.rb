class CreateTweets < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets do |t|
      t.integer  :user_id, null: false, limit: 8
      t.integer  :tweet_id, null: false, limit: 8
      t.string   :screen_name, limit: 20
      t.string   :text, null: false, limit: 140
      t.boolean  :deleted
      t.datetime :tweeted_at, null: false
      t.datetime :deleted_at
    end
    add_index :tweets, [:user_id, :deleted]
    add_index :tweets, :deleted
    add_index :tweets, :tweet_id
  end
end

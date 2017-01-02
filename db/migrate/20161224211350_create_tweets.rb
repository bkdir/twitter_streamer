class CreateTweets < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets do |t|
      t.string   :user_id, null: false
      t.string   :tweet_id, null: false
      t.string   :screen_name
      t.string   :name
      t.text     :text, null: false
      t.string   :rt_id
      t.text     :quoted_text
      t.boolean  :deleted
      t.datetime :tweeted_at
      t.datetime :deleted_at
    end
    add_index :tweets, [:user_id, :deleted]
    add_index :tweets, :deleted
    add_index :tweets, :tweet_id, unique: true
  end
end

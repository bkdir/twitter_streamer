class CreateTweets < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets do |t|
      t.string :user_id, null: false
      t.string :tweet_id, null: false
      t.string :username
      t.text :text, null: false
      t.boolean :deleted
      t.string :media_id
      t.text :media_url
      t.datetime :tweeted_at, null: false
      t.datetime :deleted_at
    end
    add_index :tweets, [:user_id, :deleted]
    add_index :tweets, :deleted
  end
end

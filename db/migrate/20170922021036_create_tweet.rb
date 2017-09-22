class CreateTweet < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets, primary_key: "tweet_id", id: :bigint, force: :cascade do |t|
      t.bigint   :user_id, null: false
      t.text     :text
      t.text     :quoted_text
      t.bigint   :rt_id
      t.boolean  :deleted, default: false
      t.datetime :created_at
      t.datetime :deleted_at
    end
    add_index :tweets, [:user_id, :deleted]
    add_foreign_key :tweets, :twitter_users, column: :user_id, primary_key: :user_id
  end
end

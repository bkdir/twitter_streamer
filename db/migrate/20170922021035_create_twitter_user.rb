class CreateTwitterUser < ActiveRecord::Migration[5.0]
  def change
    create_table :twitter_users, primary_key: "user_id", id: :bigint, force: :cascade do |t|
      t.string :screen_name
      t.string :name
      t.integer :deleted_tweets_count

      t.timestamps
    end
    add_index :twitter_users, :screen_name
  end
end

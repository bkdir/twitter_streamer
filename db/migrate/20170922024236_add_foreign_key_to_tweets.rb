class AddForeignKeyToTweets < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :tweets, :twitter_users, column: :user_id, primary_key: :user_id
  end
end

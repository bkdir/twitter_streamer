class AddIndexToTweets < ActiveRecord::Migration[5.0]
  def change
    add_index :tweets, :tweet_id
  end
end

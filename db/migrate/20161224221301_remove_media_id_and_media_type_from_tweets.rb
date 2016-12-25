class RemoveMediaIdAndMediaTypeFromTweets < ActiveRecord::Migration[5.0]
  def change
    remove_column :tweets, :media_id, :string
    remove_column :tweets, :media_url, :text
  end
end

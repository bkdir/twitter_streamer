class AddIndexToMedia < ActiveRecord::Migration[5.0]
  def change
    add_index :media, [:media_id, :tweet_id], unique: true
  end
end

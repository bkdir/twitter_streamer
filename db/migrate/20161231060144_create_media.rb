class CreateMedia < ActiveRecord::Migration[5.0]
  def change
    create_table :media do |t|
      t.string :media_id, null: false
      t.string :tweet_id, null: false
      t.string :user_id, null: false
      t.boolean :rt_media
      t.string :media_url, null: false
      t.string :media_type

      t.timestamps
    end
  end
end

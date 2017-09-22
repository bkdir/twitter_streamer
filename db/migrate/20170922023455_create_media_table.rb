class CreateMediaTable < ActiveRecord::Migration[5.0]
  def change
    create_table :media do |t|
      t.bigint   :tweet_id,   null: false
      t.string   :media_url,  null: false
      t.string   :media_type
      t.datetime :created_at, null: false
    end
    add_index :media, [:tweet_id]
    add_index :media, [:tweet_id, :media_type]
    add_foreign_key :media, :tweets, primary_key: :tweet_id
  end
end

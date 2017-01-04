class RemoveUserIdFromMedia < ActiveRecord::Migration[5.0]
  def change
    remove_column :media, :user_id, :string
  end
end

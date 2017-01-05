class ChangeDeletedColumnDefaultToFalseInMedia < ActiveRecord::Migration[5.0]
  def change
    change_column :tweets, :deleted, :boolean, :default => false
  end
end

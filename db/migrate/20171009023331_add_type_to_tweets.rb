class AddTypeToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :type, :string
  end
end

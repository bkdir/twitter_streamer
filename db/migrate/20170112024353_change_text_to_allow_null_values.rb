class ChangeTextToAllowNullValues < ActiveRecord::Migration[5.0]
  def change
    change_column_null(:tweets, :text, true)
  end
end

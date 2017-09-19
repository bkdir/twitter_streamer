class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string  :name,  null: false
      t.string  :email, null: false
      t.string  :password_digest
      t.boolean :admin, default: false
      t.datetime :last_login

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :name, unique: true
  end
end

class CreateUser < ActiveRecord::Migration[5.1]
  def change
    create_table :user do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :user, :email, unique: true
  end
end

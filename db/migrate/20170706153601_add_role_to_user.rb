class AddRoleToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :user, :role, foreign_key: true
  end
end

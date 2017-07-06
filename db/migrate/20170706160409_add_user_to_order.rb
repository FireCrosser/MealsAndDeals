class AddUserToOrder < ActiveRecord::Migration[5.1]
  def change
    add_reference :order, :user, foreign_key: true
  end
end

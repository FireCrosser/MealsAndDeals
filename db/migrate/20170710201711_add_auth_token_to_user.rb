class AddAuthTokenToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :user, :auth_token, :string
  end
end

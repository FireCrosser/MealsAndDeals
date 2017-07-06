class RemovePasswordDigestFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :user, :password_digest, :string
  end
end

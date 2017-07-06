class SetUserRoleNullToFalse < ActiveRecord::Migration[5.1]
  def change
    change_column_null :user, :role_id, false
  end
end

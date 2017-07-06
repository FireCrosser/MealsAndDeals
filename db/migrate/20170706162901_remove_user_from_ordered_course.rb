class RemoveUserFromOrderedCourse < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :ordered_course, column: :user_id
  end
end

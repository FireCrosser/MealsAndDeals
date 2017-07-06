class RemoveUserColumnFromOrderedCourse < ActiveRecord::Migration[5.1]
  def change
    remove_column :ordered_course, :user_id
  end
end

class AddUserToOrderedCourse < ActiveRecord::Migration[5.1]
  def change
    add_reference :ordered_course, :user, foreign_key: true, null: false
  end
end

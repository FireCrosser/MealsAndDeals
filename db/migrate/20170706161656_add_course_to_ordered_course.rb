class AddCourseToOrderedCourse < ActiveRecord::Migration[5.1]
  def change
    add_reference :ordered_course, :course, foreign_key: true, null: false
  end
end

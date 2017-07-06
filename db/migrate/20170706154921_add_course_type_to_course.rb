class AddCourseTypeToCourse < ActiveRecord::Migration[5.1]
  def change
    add_reference :course, :course_type, foreign_key: true, null: false
  end
end

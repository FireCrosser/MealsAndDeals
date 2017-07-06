class CreateCourseType < ActiveRecord::Migration[5.1]
  def change
    create_table :course_type do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :course_type, :name, unique: true
  end
end

class CreateOrderedCourse < ActiveRecord::Migration[5.1]
  def change
    create_table :ordered_course do |t|

      t.timestamps
    end
  end
end

class CreateCourse < ActiveRecord::Migration[5.1]
  def change
    create_table :course do |t|
      t.string :name, null: false
      t.float :price, null: false
      t.datetime :date, null: false

      t.timestamps
    end
  end
end

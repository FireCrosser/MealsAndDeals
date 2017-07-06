class CreateRole < ActiveRecord::Migration[5.1]
  def change
    create_table :role do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :role, :name, unique: true
  end
end

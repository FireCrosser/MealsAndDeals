class CreateOrder < ActiveRecord::Migration[5.1]
  def change
    create_table :order do |t|

      t.timestamps
    end
  end
end

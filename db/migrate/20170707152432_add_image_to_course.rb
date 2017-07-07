class AddImageToCourse < ActiveRecord::Migration[5.1]
  def change
    add_column :course, :image, :string
  end
end

class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :slug
      t.integer :parent_id, index: true

      t.timestamps
    end

    add_foreign_key :categories, :categories, column: :parent_id
  end
end

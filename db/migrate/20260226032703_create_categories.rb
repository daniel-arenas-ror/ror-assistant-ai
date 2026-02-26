class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :slug
      t.references :company, null: false, foreign_key: true
      t.integer :parent_id, index: true

      t.timestamps
    end

    add_index :categories, [:company_id, :slug], unique: true
    add_foreign_key :categories, :categories, column: :parent_id
  end
end

class CreatePageLayouts < ActiveRecord::Migration[8.1]
  def change
    create_table :page_layouts do |t|
      t.references :company, null: false, foreign_key: true
      t.integer :page_type, null: false, default: 0
      t.string :meta_title, null: false
      t.string :path, null: false
      t.integer :version, null: false, default: 0

      t.timestamps
    end

    add_index :page_layouts, [:company_id, :path, :version], unique: true
  end
end

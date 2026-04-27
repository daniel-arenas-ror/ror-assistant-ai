class CreatePageComponents < ActiveRecord::Migration[8.1]
  def change
    create_table :page_components do |t|
      t.references :page_layouts, null: false, foreign_key: true
      t.string :component_type, null: false
      t.integer :position, default: 0
      t.jsonb :config, default: {}

      t.timestamps
    end
    add_index :page_components, :component_type
  end
end

class CreateAssistants < ActiveRecord::Migration[8.0]
  def change
    create_table :assistants do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name, null: false
      t.text :instructions, null: false
      t.text :model
      t.string :assistant_id, null: false

      t.timestamps
    end
  end
end

class CreateAssistantFiles < ActiveRecord::Migration[8.1]
  def change
    create_table :assistant_files do |t|
      t.references :assistant, null: false, foreign_key: true
      t.string :resource_name
      t.string :file_name

      t.timestamps
    end
  end
end

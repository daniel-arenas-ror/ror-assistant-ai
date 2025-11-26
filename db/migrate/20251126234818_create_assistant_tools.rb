class CreateAssistantTools < ActiveRecord::Migration[8.1]
  def change
    create_table :assistant_tools do |t|
      t.references :assistant, null: false, foreign_key: true
      t.references :tool, null: false, foreign_key: true

      t.timestamps
    end
  end
end

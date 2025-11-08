class AddSlugToAssistant < ActiveRecord::Migration[8.0]
  def change
    add_column :assistants, :slug, :string

    add_index :assistants, :slug, unique: true
  end
end

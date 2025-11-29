class AddConfigFieldToAssistant < ActiveRecord::Migration[8.1]
  def change
    add_column :assistants, :temperature, :float, default: 1.0
    add_column :assistants, :top_p, :float, default: 1.0
  end
end

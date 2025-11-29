class AddConfigFieldToAssistant < ActiveRecord::Migration[8.1]
  def change
    add_column :assistants, :temperature, :float
    add_column :assistants, :top_p, :float
  end
end

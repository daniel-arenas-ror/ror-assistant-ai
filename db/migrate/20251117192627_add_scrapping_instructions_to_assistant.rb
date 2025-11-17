class AddScrappingInstructionsToAssistant < ActiveRecord::Migration[8.1]
  def change
    add_column :assistants, :scrapping_instructions, :text
  end
end

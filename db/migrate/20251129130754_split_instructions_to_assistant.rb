class SplitInstructionsToAssistant < ActiveRecord::Migration[8.1]
  def change
    add_column :assistants, :role, :text
    add_column :assistants, :task, :text
    add_column :assistants, :context, :text
    add_column :assistants, :reasoning, :text
    add_column :assistants, :outputs, :text
    add_column :assistants, :conditions, :text
  end
end

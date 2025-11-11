class AddCurrentRunToConversation < ActiveRecord::Migration[8.0]
  def change
    add_column :conversations, :current_run, :string
  end
end

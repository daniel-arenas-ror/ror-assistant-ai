class AddCompanyToConversation < ActiveRecord::Migration[8.1]
  def change
    add_reference :conversations, :company, null: false, foreign_key: true
  end
end

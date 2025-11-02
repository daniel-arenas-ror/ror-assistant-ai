class AddFieldToCompany < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :email, :string
    add_column :companies, :phone, :string
    add_column :companies, :ai_source, :string, default: 'openai'
  end
end

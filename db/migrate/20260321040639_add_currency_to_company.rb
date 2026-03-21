class AddCurrencyToCompany < ActiveRecord::Migration[8.1]
  def change
    add_column :companies, :currency, :string, null: false, default: 'USD'
  end
end

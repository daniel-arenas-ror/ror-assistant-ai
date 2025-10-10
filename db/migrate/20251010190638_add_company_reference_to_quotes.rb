class AddCompanyReferenceToQuotes < ActiveRecord::Migration[8.0]
  def up
    add_column :quotes, :company_id, :integer
    
    Quote.update_all(company_id: Company.first.id)

    add_foreign_key :quotes, :companies, null: false
  end

  def down
    remove_foreign_key :quotes, :companies
    remove_column :quotes, :company_id
  end
end

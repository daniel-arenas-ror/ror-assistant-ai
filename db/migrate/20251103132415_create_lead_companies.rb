class CreateLeadCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :lead_companies do |t|
      t.references :lead, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.text :summary

      t.timestamps
    end
  end
end

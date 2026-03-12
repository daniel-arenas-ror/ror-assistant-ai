class CreateCompanyItemConfigurations < ActiveRecord::Migration[8.1]
  def change
    create_table :company_item_configurations do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name
      t.string :value

      t.timestamps
    end

    add_index :company_item_configurations, [:company_id, :name], unique: true
  end
end

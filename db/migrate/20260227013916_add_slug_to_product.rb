class AddSlugToProduct < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :slug, :string
    add_index :products, [:company_id, :slug], unique: true
  end
end

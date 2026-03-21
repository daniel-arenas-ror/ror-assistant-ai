class UpdateFieldPriceAllTables < ActiveRecord::Migration[8.1]
  def change
    remove_column :products, :price, :float
    remove_column :variants, :price, :float

    add_monetize :products, :price
    add_monetize :variants, :price
  end
end

class AddPriceToProduct < ActiveRecord::Migration[8.0]
  def change
    add_column :real_estates, :price, :string
  end
end

class AddActiveToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :active, :boolean, default: false
  end
end

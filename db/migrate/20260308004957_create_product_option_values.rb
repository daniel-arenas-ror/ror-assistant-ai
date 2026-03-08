class CreateProductOptionValues < ActiveRecord::Migration[8.1]
  def change
    create_table :product_option_values do |t|
      t.references :product, null: false, foreign_key: true
      t.references :option_value, null: false, foreign_key: true

      t.timestamps
    end
  end
end

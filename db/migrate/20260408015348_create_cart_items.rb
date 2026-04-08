class CreateCartItems < ActiveRecord::Migration[8.1]
  def change
    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :variant, null: false, foreign_key: true
      t.monetize :total
      t.monetize :sub_total
      t.integer :quantity

      t.timestamps
    end
  end
end

class CreateCarts < ActiveRecord::Migration[8.1]
  def change
    create_table :carts do |t|
      t.references :lead, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.monetize :total, default: 0, null: false
      t.monetize :sub_total, default: 0, null: false

      t.timestamps
    end
  end
end

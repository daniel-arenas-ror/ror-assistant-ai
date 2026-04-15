class CreateLineItems < ActiveRecord::Migration[8.1]
  def change
    create_table :line_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :variant, null: false, foreign_key: true
      t.integer :quantity, default: 0, null: false
      t.monetize :total
      t.monetize :sub_total

      t.timestamps
    end
  end
end

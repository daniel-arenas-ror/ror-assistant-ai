class CreateOrderDeliveryTransitions < ActiveRecord::Migration[8.1]
  def change
    create_table :order_delivery_transitions do |t|
      t.string :to_state
      t.jsonb :metadata
      t.integer :sort_key
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end

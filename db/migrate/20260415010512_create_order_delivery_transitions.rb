class CreateOrderDeliveryTransitions < ActiveRecord::Migration[8.1]
  def change
    create_table :order_delivery_transitions do |t|
      t.string :to_state
      t.jsonb :metadata, default: {}
      t.integer :sort_key
      t.boolean :most_recent, null: false, default: false
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end

    add_index :order_delivery_transitions, [:order_id, :most_recent], unique: true, where: "most_recent", name: "index_order_delivery_transitions_parent_most_recent"
    add_index :order_delivery_transitions, [:order_id, :sort_key], unique: true, name: "index_order_delivery_transitions_parent_sort"
  end
end

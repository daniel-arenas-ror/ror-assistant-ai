class CreateOrderPaymentTransitions < ActiveRecord::Migration[8.1]
  def change
    create_table :order_payment_transitions do |t|
      t.string :to_state
      t.jsonb :metadata
      t.integer :sort_key
      t.integer :order_id

      t.timestamps
    end
  end
end

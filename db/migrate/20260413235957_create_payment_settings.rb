class CreatePaymentSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :payment_settings do |t|
      t.references :company, null: false, foreign_key: true
      t.string :provider
      t.text :api_key_ciphertext
      t.text :secret_ciphertext

      t.timestamps
    end
  end
end

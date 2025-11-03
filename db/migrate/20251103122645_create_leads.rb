class CreateLeads < ActiveRecord::Migration[8.0]
  def change
    create_table :leads do |t|
      t.string :email
      t.string :phone
      t.string :name
      t.text :preferences
      t.jsonb :extra_data

      t.timestamps
    end
  end
end

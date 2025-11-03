class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.references :lead, null: false, foreign_key: true
      t.references :assistant, null: false, foreign_key: true
      t.string :thread_id
      t.jsonb :meta_data

      t.timestamps
    end
  end
end

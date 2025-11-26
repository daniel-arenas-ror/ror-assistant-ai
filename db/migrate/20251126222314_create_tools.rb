class CreateTools < ActiveRecord::Migration[8.1]
  def change
    create_table :tools do |t|
      t.string :name
      t.jsonb :function, default: {}

      t.timestamps
    end
  end
end

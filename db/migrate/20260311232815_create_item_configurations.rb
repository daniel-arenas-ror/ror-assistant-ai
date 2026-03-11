class CreateItemConfigurations < ActiveRecord::Migration[8.1]
  def change
    create_table :item_configurations do |t|
      t.string :name
      t.text :description
      t.jsonb :options

      t.timestamps
    end
  end
end

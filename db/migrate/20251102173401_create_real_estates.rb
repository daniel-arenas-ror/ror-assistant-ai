class CreateRealEstates < ActiveRecord::Migration[8.0]
  def change
    create_table :real_estates do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name
      t.string :code
      t.string :url
      t.jsonb :url_images
      t.string :description
      t.string :amenities
      t.string :location

      t.timestamps
    end
  end
end

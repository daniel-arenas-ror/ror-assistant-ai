class AddEmbeddingToRealEstate < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'vector'
    add_column :products, :embedding, :vector, default: []
  end
end

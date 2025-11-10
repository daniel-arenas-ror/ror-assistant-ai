class AddEmbeddingToRealEstate < ActiveRecord::Migration[8.0]
  def change
    add_column :real_estates, :embedding, :vector, limit: 3072
  end
end

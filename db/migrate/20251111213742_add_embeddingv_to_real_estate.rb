class AddEmbeddingvToRealEstate < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'vector'
    add_column :real_estates, :embeddingv, :vector, limit: 1536
  end
end

require 'pgvector'

class RealEstate < ApplicationRecord
  #include Pgvector::Model
  #vector :embedding, limit: 3072

  belongs_to :company

  def embed_input
    <<~EOS
      name: #{name}
      code: #{code}
      url: #{url}
      price: #{price}
      description: #{description}
      amenities: #{amenities}
      location: #{location}
    EOS
  end
end

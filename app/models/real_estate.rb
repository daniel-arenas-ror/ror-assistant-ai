class RealEstate < ApplicationRecord
  include Pgvector::Model
  vector :embedding, limit: 3072

  belongs_to :company

  private

  def embed_input
    <<~EOS
      name: #{title}
      code: #{category}
      url: #{keywords}
      description: #{description}
      amenities: #{amenities}
      location: #{location}
    EOS
  end
end

class RealEstate < ApplicationRecord
  include Pgvector::Model
  vector :embedding, limit: 3072

  belongs_to :company
end

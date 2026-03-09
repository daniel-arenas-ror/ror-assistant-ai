class ProductOptionValue < ApplicationRecord
  belongs_to :product
  belongs_to :option_value

  validates :option_value_id, uniqueness: {
    scope: :product_id, 
    message: "has already been assigned to this product"
  }
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [150, 200]
    attachable.variant :medium, resize_to_limit: [450, 600]
    attachable.variant :large, resize_to_limit: [900, 1200]
  end
end

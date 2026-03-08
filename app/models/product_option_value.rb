class ProductOptionValue < ApplicationRecord
  belongs_to :product
  belongs_to :option_value
end

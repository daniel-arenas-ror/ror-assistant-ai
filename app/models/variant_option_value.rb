class VariantOptionValue < ApplicationRecord
  belongs_to :company
  belongs_to :variant
  belongs_to :option_value
end

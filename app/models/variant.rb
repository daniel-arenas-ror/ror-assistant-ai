class Variant < ApplicationRecord
  belongs_to :company
  belongs_to :product

  has_many :variant_option_values
  has_many :option_values, through: :variant_option_values, dependent: :destroy
  has_many :option_types, -> { distinct }, through: :option_values

  accepts_nested_attributes_for :variant_option_values, allow_destroy: true

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [150, 200]
    attachable.variant :medium, resize_to_limit: [450, 600]
    attachable.variant :large, resize_to_limit: [900, 1200]
  end
end

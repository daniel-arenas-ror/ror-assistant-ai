class Variant < ApplicationRecord
  belongs_to :company
  belongs_to :product

  has_many :variant_option_values
  has_many :option_values, through: :variant_option_values
  has_many :option_types, -> { distinct }, through: :option_values

  accepts_nested_attributes_for :variant_option_values, allow_destroy: true
end

class OptionValue < ApplicationRecord
  belongs_to :company
  belongs_to :option_type

  has_many :option_value_variants, dependent: :destroy
  has_many :variants, through: :option_value_variants

  validates :name, presence: true
end

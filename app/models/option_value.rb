class OptionValue < ApplicationRecord
  belongs_to :company
  belongs_to :option_type

  validates :name, presence: true
end

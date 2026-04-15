class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :variant

  monetize :total_cents, as: :total
  monetize :sub_total_cents, as: :sub_total
end

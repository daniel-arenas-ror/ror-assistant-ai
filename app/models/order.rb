class Order < ApplicationRecord
  belongs_to :company
  belongs_to :lead

  monetize :total_cents, as: :total
  monetize :sub_total_cents, as: :sub_total
end

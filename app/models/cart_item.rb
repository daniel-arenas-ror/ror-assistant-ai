class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :variant

  monetize :total_cents, as: :total
  monetize :sub_total_cents, as: :sub_total

  before_validation :sync_currency_from_company

  private

  def sync_currency_from_company
    self.total_currency = cart.total_currency
    self.sub_total_currency = cart.sub_total_currency
  end
end

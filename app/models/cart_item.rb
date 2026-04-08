class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :variant

  before_validation :sync_currency_from_company

  private

  def sync_currency_from_company
    self.total_currency = cart.total_currency
    self.sub_total_currency = company.sub_total_currency
  end
end

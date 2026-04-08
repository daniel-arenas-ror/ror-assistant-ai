class Cart < ApplicationRecord
  belongs_to :lead
  belongs_to :company

  has_many :cart_items, dependent: :destroy

  monetize :total_cents, as: :total
  monetize :sub_total_cents, as: :sub_total

  before_validation :sync_currency_from_company

  def update_total!
    self.total     = cart_items.sum(&:total_cents)
    self.sub_total = cart_items.sum(&:sub_total_cents)
    save!
  end

  private

  def sync_currency_from_company
    self.total_currency = company.currency
    self.sub_total_currency = company.currency
  end
end

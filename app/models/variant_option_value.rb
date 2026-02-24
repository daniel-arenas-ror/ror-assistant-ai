class VariantOptionValue < ApplicationRecord
  belongs_to :company
  belongs_to :variant
  belongs_to :option_value
  
  before_validation :ensure_company

  validates :company_id, presence: true

  private

  def ensure_company
    self.company_id ||= variant&.company_id || option_value&.company_id
  end
end

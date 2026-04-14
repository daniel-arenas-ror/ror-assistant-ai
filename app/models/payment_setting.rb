class PaymentSetting < ApplicationRecord
  belongs_to :company

  has_encrypted :api_key
  has_encrypted :secret

  PROVIDERS = ["stripe"].freeze
  
  validates :provider_name, inclusion: { in: PROVIDERS }
end

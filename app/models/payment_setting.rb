class PaymentSetting < ApplicationRecord
  belongs_to :company

  has_encrypted :api_key
  has_encrypted :secret
end

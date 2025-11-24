class Lead < ApplicationRecord
  has_many :lead_companies  
  has_many :companies, through: :lead_companies

  has_many :conversations
end

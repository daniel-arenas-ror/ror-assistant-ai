class LeadCompany < ApplicationRecord
  belongs_to :lead
  belongs_to :company
end

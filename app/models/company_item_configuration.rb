class CompanyItemConfiguration < ApplicationRecord
  belongs_to :company

  enum :versions, {
    draft: 0,
    published: 1
  }
end

class CompanyItemConfiguration < ApplicationRecord
  belongs_to :company

  enum status: {
    draft: 0,
    published: 1
  }
end

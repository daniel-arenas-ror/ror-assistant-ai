class CompanyItemConfiguration < ApplicationRecord
  belongs_to :company

  enum version: {
    draft: 0,
    published: 1
  }
end

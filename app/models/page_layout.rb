class PageLayout < ApplicationRecord
  belongs_to :company
  has_many :page_components

  enum :page_type, {
    system: 0,
    custom: 1
  }

  enum :version, {
    draft: 0,
    published: 1
  }

end

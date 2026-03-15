module Queries
  class CategoryQuery < BaseQuery
    type Types::CategoryType, null: false
    argument :company_id, ID, required: true
    argument :category_slug, ID, required: true

    description "Returns a list of all categories for a company."

    def resolve(company_id:, category_slug:, limit:, offset:)
      ::Category.find_by(company_id: company_id, slug: category_slug)
    end
  end
end

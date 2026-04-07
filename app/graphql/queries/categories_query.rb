module Queries
  class CategoriesQuery < BaseQuery
    type [Types::CategoryType], null: false
    argument :company_id, ID, required: true

    description "Returns a list of all categories for a company."

    def resolve(company_id:, limit:, offset:)
      p " Caategory context resolver "
      p context[:current_user]

      ::Category.where(company_id: company_id, parent_id: nil)
          .includes(:sub_categories)
          .order(:name)
          .limit(limit)
          .offset(offset)
    end
  end
end

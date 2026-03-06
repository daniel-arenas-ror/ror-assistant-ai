module Queries
  class CategoryProductsQuery < BaseQuery
    type [Types::ProductType], null: false

    argument :company_id, ID, required: true
    argument :category_slug, String, required: true

    description "Returns products belonging to a given category (including all descendants)."

    def resolve(company_id:, category_slug:, limit:, offset:, **args)
      company = Company.find_by(id: company_id)
      return [] unless company

      category = company.categories.find_by(slug: category_slug)
      return [] unless category

      ids = category.all_ids
      products = Product.joins(:categories)
                        .where(categories: { id: ids })
                        .order(:name)
                        .distinct

      products.limit(limit).offset(offset)
    end
  end
end

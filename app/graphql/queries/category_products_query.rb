module Queries
  class CategoryProductsQuery < BaseQuery
    type [Types::ProductType], null: false

    argument :company_id, ID, required: true
    argument :category_slug, String, required: true

    description "Returns a list of all companies."

    def resolve(company_id: , category_slug: , limit: , offset: ,**args)
      company = Company.find_by(id: company_id)
      category = company.categories.find_by(slug: category_slug)
      category.products.limit(limit)
          .offset(offset)
    end
  end
end

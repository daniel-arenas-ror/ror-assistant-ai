module Queries
  class ProductQuery < BaseQuery
    type Types::ProductType, null: false
    argument :company_id, ID, required: true
    argument :product_slug, ID, required: true

    description "Returns a product by slug."

    def resolve(company_id:, product_slug:, **)
      ::Product.find_by(company_id: company_id, slug: product_slug)
    end
  end
end

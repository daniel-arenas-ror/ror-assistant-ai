module Queries
  class CategoryProductsQuery < BaseQuery
    type [Types::ProductType], null: false

    argument :company_id, ID, required: true
    argument :category_slug, String, required: true
    argument :filter, GraphQL::Types::JSON, required: false, default_value: {}

    # Ensure limit and offset are defined if they aren't in BaseQuery
    argument :limit, Integer, required: false, default_value: 20
    argument :offset, Integer, required: false, default_value: 0

    description "Returns products belonging to a given category (including all descendants)."

    def resolve(company_id:, category_slug:, limit:, offset:, filter:, **args)
      company = Company.find_by(id: company_id)
      return [] unless company

      category = company.categories.find_by(slug: category_slug)
      return [] unless category

      ids = category.all_ids
      
      # 1. Start with your base scope
      base_scope = Product.includes(:variants, :product_option_values)
                          .joins(:categories)
                          .active
                          .where(categories: { id: ids })

      # 2. Apply Ransack filtering
      # The filter hash will look like: { "variants_option_values_id_in" => [1, 2] }
      search = base_scope.ransack(filter)
      
      # 3. Get results and apply ordering/pagination
      # distinct(true) is required because joining categories and variants 
      # can return duplicate product rows
      products = search.result(distinct: true)
                       .order(:name)
                       .limit(limit)
                       .offset(offset)

      products
    end
  end
end

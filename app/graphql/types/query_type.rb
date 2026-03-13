# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :categories, resolver: ::Queries::CategoryQuery
    field :company, resolver: ::Queries::CompanyQuery
    field :category_products, resolver: ::Queries::CategoryProductsQuery
    field :options_field_filter, resolver: ::Queries::OptionsTypeQuery
  end
end

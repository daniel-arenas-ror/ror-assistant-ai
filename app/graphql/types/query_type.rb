# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :categories, resolver: ::Queries::CategoryQuery
    field :company, resolver: ::Queries::CompanyQuery
  end
end

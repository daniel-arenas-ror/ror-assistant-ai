module Queries
  class BaseQuery < GraphQL::Schema::Resolver
    argument :limit, Integer, required: false, default_value: 10
    argument :offset, Integer, required: false, default_value: 0
  end
end

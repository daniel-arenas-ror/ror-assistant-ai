module Queries
  class OptionsTypeQuery < BaseQuery
    type [Types::OptionType], null: false
    argument :company_id, ID, required: true

    description "Return searchable option type"

    def resolve(company_id: , **args)
      OptionType.filterable.where(company_id: company_id)
    end
  end
end

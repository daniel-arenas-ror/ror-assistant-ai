module Types
  class OptionType < Types::BaseObject
    description "An filtering option type for a company."

    field :id, ID, null: false
    field :name, String, null: false
    field :option_values, [Types::OptionValueType], null: true
  end
end

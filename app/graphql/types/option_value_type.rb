module Types
  class OptionValueType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :label, String, null: true
    field :option_type_name, String, null: false
  end
end

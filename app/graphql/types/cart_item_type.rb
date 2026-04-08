module Types
  class CartItemType < Types::BaseObject
    field :id, ID, null: false
    field :variant, Types::VariantType, null: false
    field :quantity, Integer, null: false
    field :total_cents, Integer, null: true
    field :sub_total_cents, Integer, null: true
    field :formatted_total, String, null: true
    field :formatted_sub_total, String, null: true
  end
end

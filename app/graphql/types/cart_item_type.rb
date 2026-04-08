module Types
  class CartItemType < Types::BaseObject
    field :id, ID, null: false
    field :variant, Types::VariantType, null: false
    field :quantity, Integer, null: false
    field :total, Float, null: false
    field :subtotal, Float, null: false
    field :formatted_total, String, null: true
    field :formatted_sub_total, String, null: true
  end
end

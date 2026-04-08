module Types
  class CartType < Types::BaseObject
    field :id, ID, null: false
    field :cart_items, [Types::CartItemType], null: false
    field :total_cents, Integer, null: true
    field :sub_total_cents, Integer, null: true
    field :formatted_total, String, null: true
    field :formatted_sub_total, String, null: true

  end
end

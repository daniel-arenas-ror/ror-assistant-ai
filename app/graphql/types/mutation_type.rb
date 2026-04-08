# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description "The root mutation type (currently empty)"

    field :add_to_cart, mutation: Mutations::AddToCart
    field :remove_from_cart, mutation: Mutations::RemoveFromCart
  end
end

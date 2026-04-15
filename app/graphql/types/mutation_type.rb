# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description "The root mutation type (currently empty)"

    field :add_to_cart, mutation: Mutations::AddToCart
    field :remove_to_cart, mutation: Mutations::RemoveToCart
    field :checkout, mutation: Mutations::CheckoutMutation
  end
end

module Queries
  class CartQuery < BaseQuery
    type Types::CartType, null: true

    def resolve
      user = context[:current_user]
      return nil unless user

      user.cart || user.create_cart
    end
  end
end

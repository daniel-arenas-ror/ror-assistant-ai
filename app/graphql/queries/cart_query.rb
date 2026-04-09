module Queries
  class CartQuery < BaseQuery
    type Types::CartType, null: true
    argument :company_id, ID, required: true

    def resolve(company_id: )
      user = context[:current_user]
      return nil unless user

      user.cart || user.create_cart
    end
  end
end

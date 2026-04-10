module Queries
  class CartQuery < BaseQuery
    type Types::CartType, null: true
    argument :company_id, ID, required: true

    def resolve(company_id: , **)
      user = context[:current_user]
      return nil unless user

      user.carts.find_by(company_id: company_id) || user.carts.create!(company_id: company_id)
    end
  end
end

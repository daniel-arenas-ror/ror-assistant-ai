module Mutations
  class AddToCart < BaseMutation
    argument :variant_id, ID, required: true
    argument :company_id, ID, required: true
    argument :quantity, Integer, required: true

    type Types::CartType

    def authenticate?
      context[:current_user] || raise(GraphQL::ExecutionError, "Authentication required")
    end

    def resolve(variant_id:, quantity:, company_id:)
      user = context[:current_user]

      cart = user.carts.find_by(company_id: company_id) || user.carts.create(company_id: company_id)
      cart_item = cart.cart_items.find_or_initialize_by(variant_id: variant_id)

      if cart_item.new_record?
        cart_item.quantity = quantity
      else
        cart_item.quantity += quantity
      end

      variant = Variant.find(variant_id)

      cart_item.total = variant.price * cart_item.quantity
      cart_item.sub_total = variant.price * cart_item.quantity

      if cart_item.save
        cart.update_total!
        cart
      else
        raise GraphQL::ExecutionError, cart_item.errors.full_messages.join(", ")
      end
    end
  end
end

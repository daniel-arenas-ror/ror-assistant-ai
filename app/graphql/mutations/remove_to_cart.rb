module Mutations
  class RemoveToCart < BaseMutation
    # We use the variant_id to identify which line to remove
    argument :variant_id, ID, required: true
    argument :quantity, Integer, required: true

    type Types::CartType

    def authenticate?
      context[:current_user] || raise(GraphQL::ExecutionError, "Authentication required")
    end

    def resolve(variant_id:, quantity:)
      user = context[:current_user]

      cart = user.cart
      raise GraphQL::ExecutionError, "Cart not found" unless cart

      cart_item = cart.cart_items.find_by(variant_id: variant_id)
      variant = Variant.find(variant_id)

      if cart_item
        cart_item.quantity -= quantity
        cart_item.total = variant.price * cart_item.quantity
        cart_item.sub_total = variant.price * cart_item.quantity

        cart_item.save!

        cart_item.destroy if cart_item.quantity == 0

        cart.update_total!

        cart
      else
        raise GraphQL::ExecutionError, "Item not found in cart"
      end
    end
  end
end
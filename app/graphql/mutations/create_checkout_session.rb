module Mutations
  class CreateCheckoutSession < BaseMutation
    type Types::CheckoutType # Create a type that returns client_secret

    def resolve
      user = context[:current_user]
      cart = user.cart
      company = user.company # or user.store.company

      # The Factory handles the logic based on the has_one relation
      gateway = PaymentGateways::Factory.build(company)

      intent = gateway.create_intent(
        amount_cents: cart.total_cents,
        currency: cart.currency,
        metadata: { cart_id: cart.id, user_id: user.id }
      )

      {
        client_secret: intent.client_secret,
        publishable_key: company.payment_setting.settings['publishable_key'], # For React
        total_display: cart.total.format
      }
    end
  end
end

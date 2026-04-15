module Mutations
  class CheckoutMutation < BaseMutation
    description "Copies cart → order + line items, then creates a payment intent"

    field :payment_intent, Types::PaymentIntentType, null: true
    field :errors,         [String],                 null: false

    def resolve
      current_user = context[:current_user]
      cart         = current_user.cart
      company      = cart.company
      gateway      = PaymentGateways::Factory.build(company)

      order = nil

      ActiveRecord::Base.transaction do
        order = create_order!(cart, company)
        create_line_items!(order, cart)
        order.reload
      end

      intent = gateway.create_intent(
        amount_cents: order.total_cents,
        currency:     order.total_currency.downcase,
        metadata:     { order_id: order.id, company_id: company.id, lead_id: order.lead_id }
      )

      {
        payment_intent: {
          adapter:       gateway.adapter_name,
          public_key:    gateway.public_key,
          client_secret: intent.client_secret,
          order_id:      order.id
        },
        errors: []
      }
    rescue ActiveRecord::RecordInvalid => e
      { payment_intent: nil, errors: e.record.errors.full_messages }
    rescue ArgumentError => e
      { payment_intent: nil, errors: [e.message] }
    rescue ::Stripe::StripeError => e
      { payment_intent: nil, errors: [e.message] }
    end

    private

    def create_order!(cart, company)
      Order.create!(
        company_id:          company.id,
        lead_id:             cart.lead_id,
        sub_total_cents:     cart.sub_total_cents,
        sub_total_currency:  cart.sub_total_currency,
        total_cents:         cart.total_cents,
        total_currency:      cart.total_currency
      )
    end

    def create_line_items!(order, cart)
      cart.cart_items.each do |item|
        LineItem.create!(
          order_id:           order.id,
          variant_id:         item.variant_id,
          quantity:           item.quantity,
          sub_total_cents:    item.sub_total_cents,
          sub_total_currency: item.sub_total_currency,
          total_cents:        item.total_cents,
          total_currency:     item.total_currency
        )
      end
    end
  end
end

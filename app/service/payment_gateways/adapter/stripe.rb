module PaymentGateways
  class Stripe < BaseAdapter
    def initialize(settings)
      @secret_key = settings['secret_key']
      @publishable_key = settings['publishable_key']
      
      # We set the key per-request to ensure multi-tenant safety
      Stripe.api_key = @secret_key
    end

    def create_intent(amount_cents:, currency:, metadata: {})
      Stripe::PaymentIntent.create({
        amount: amount_cents,
        currency: currency,
        metadata: metadata,
        automatic_payment_methods: { enabled: true }
      })
    end
  end
end

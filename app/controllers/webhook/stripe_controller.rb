module  Webhook
  class StripeController < ApplicationController
    def receive
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = nil

      render json: { message: "Received" }, status: 200
      return

      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, Rails.application.credentials.dig(:stripe, :webhook_secret)
        )
      rescue JSON::ParserError => e
        render json: { error: "Invalid payload" }, status: 400 and return
      rescue Stripe::SignatureVerificationError => e
        render json: { error: "Invalid signature" }, status: 400 and return
      end

      case event.type
      when 'payment_intent.succeeded'
        payment_intent = event.data.object
        handle_payment_intent_succeeded(payment_intent)
      else
        Rails.logger.info "Unhandled event type: #{event.type}"
      end

      render json: { message: "Received" }, status: 200
    end
  end
end

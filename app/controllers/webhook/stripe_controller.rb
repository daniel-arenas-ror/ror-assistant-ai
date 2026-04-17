module  Webhook
  class StripeController < Webhook::BaseController
    def receive
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = nil

      begin
        event = Stripe::Webhook.construct_event(payload, sig_header, ENV.fetch('WEBHOOK_KEY', ''))
      rescue JSON::ParserError => e
        render json: { error: "Invalid payload" }, status: 400 and return
      rescue Stripe::SignatureVerificationError => e
        render json: { error: "Invalid signature" }, status: 400 and return
      end

      payment_intent = event.data.object
      company_id = payment_intent.metadata.company_id
      order_id = payment_intent.metadata.order_id
      order = Order.find_by(id: order_id, company_id: company_id)

      if order.nil?
        Rails.logger.error "Order not found for company_id: #{company_id}, order_id: #{order_id}"
        render json: { error: "Order not found" }, status: 404 and return
      end

      case event.type
      when 'payment_intent.succeeded'
        order.payment_machine.transition_to!(:paid)
      when 'payment_intent.created'
        order.payment_machine.transition_to!(:pending)
      when 'payment_intent.payment_failed'
        order.payment_machine.transition_to!(:failed)
      else
        Rails.logger.info "Unhandled event type: #{event.type}"
      end

      render json: { message: "Received" }, status: 200
    end
  end
end

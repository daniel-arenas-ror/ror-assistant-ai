module PaymentGateways
  class Factory
    def self.build(company)
      setting = company.payment_setting
      
      raise "No payment method configured for this store" if setting.nil?

      case setting.provider_name
      when 'stripe'
        PaymentGateways::Adapter::Stripe.new(setting.settings)
      else
        raise "Unsupported payment provider: #{setting.provider_name}"
      end
    end
  end
end

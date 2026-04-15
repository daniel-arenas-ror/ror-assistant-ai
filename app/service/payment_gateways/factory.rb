module PaymentGateways
  class Factory
    def self.build(company)
      setting = company.payment_setting
      
      raise "No payment method configured for this store" if setting.nil?

      case setting.provider
      when 'stripe'
        PaymentGateways::Adapter::Stripe.new(setting)
      else
        raise "Unsupported payment provider: #{setting.provider}"
      end
    end
  end
end

module PaymentGateways
  class Factory

    ADAPTERS = {
      'stripe' => PaymentGateways::Adapter::Stripe
      # 'payu'  => PaymentGateways::PayU
    }.freeze

    def self.build(company)

      p " ** build ** "
      setting = company.payment_setting
      raise ArgumentError, "No payment setting for company #{company.id}" unless setting

      adapter_class = ADAPTERS[setting.provider]
      raise ArgumentError, "Unknown payment provider: #{setting.provider}" unless adapter_class

      p " ** factory ** "
      adapter_class.new(setting)
    end
  end
end

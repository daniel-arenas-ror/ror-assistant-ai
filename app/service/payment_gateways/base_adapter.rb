module PaymentGateways
  class BaseAdapter
    def initialize(company)
      @settings = company.payment_settings.find_by(active: true)
    end

    def create_payment_intent(amount:, currency:, metadata:)
      raise NotImplementedError, "Each provider must implement this"
    end
  end
end

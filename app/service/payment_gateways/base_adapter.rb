module PaymentGateways
  class BaseAdapter
    def initialize(company)
      @settings = company.payment_setting
    end

    def create_payment_intent(amount:, currency:, metadata:)
      raise NotImplementedError, "Each provider must implement this"
    end
  end
end

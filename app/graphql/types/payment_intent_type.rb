module Types
  class PaymentIntentType < Types::BaseObject
    field :adapter,       String, null: false
    field :public_key,    String, null: false
    field :client_secret, String, null: false
    field :order_id,      ID,     null: false
  end
end

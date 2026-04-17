class OrderPaymentTransition < ApplicationRecord
  validates :to_state, inclusion: { in: PaymentStateMachine.states }

  belongs_to :order, inverse_of: :payment_transitions
end

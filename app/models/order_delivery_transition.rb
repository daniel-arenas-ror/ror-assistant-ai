class OrderDeliveryTransition < ApplicationRecord
  validates :to_state, inclusion: { in: DeliveryStateMachine.states }

  belongs_to :order, inverse_of: :delivery_transitions
end

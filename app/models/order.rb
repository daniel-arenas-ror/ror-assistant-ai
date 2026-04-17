class Order < ApplicationRecord
  belongs_to :company
  belongs_to :lead

  has_many :payment_transitions, class_name: "OrderPaymentTransition", autosave: false
  has_many :delivery_transitions, class_name: "OrderDeliveryTransition", autosave: false

  monetize :total_cents, as: :total
  monetize :sub_total_cents, as: :sub_total

  def payment_machine
    @payment_machine ||= PaymentStateMachine.new(self,
                            transition_class: OrderPaymentTransition,
                            association_name: :payment_transitions
                          )
  end

  def delivery_machine
    @delivery_machine ||= DeliveryStateMachine.new(self,
                            transition_class: OrderDeliveryTransition,
                            association_name: :delivery_transitions
                          )
  end

  def payment_status
    payment_machine.current_state
  end

  def delivery_status
    delivery_machine.current_state
  end
end

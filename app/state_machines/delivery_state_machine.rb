class DeliveryStateMachine
  include Statesman::Machine

  state :unshipped, initial: true
  state :shipped
  state :delivered
  state :returned

  guard_transition(from: :unshipped, to: :shipped) do |order|
    order.payment_machine.in_state?(:paid)
  end

  transition from: :unshipped, to: :shipped
  transition from: :shipped,   to: [:delivered, :returned]
end

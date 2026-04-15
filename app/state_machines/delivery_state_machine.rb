class DeliveryStateMachine
  include Statesman::Machine

  state :unshipped, initial: true
  state :shipped
  state :delivered
  state :returned

  transition from: :unshipped, to: :shipped
  transition from: :shipped,   to: [:delivered, :returned]
end

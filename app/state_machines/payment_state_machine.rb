class PaymentStateMachine
  include Statesman::Machine

  state :started, initial: true
  state :pending
  state :paid
  state :failed
  state :refunded
  state :cancelled

  transition from: :started, to: [:pending, :cancelled]
  transition from: :pending, to: [:paid, :failed]
  transition from: :paid,    to: :refunded
end

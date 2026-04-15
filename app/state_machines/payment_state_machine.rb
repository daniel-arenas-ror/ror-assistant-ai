class PaymentStateMachine
  include Statesman::Machine

  state :pending, initial: true
  state :paid
  state :failed
  state :refunded

  transition from: :pending, to: [:paid, :failed]
  transition from: :paid,    to: :refunded
end

class Message < ApplicationRecord
  belongs_to :conversation

  scope :ordered, -> {
    order(created_at: :desc)
  }

end

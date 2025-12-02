class Message < ApplicationRecord
  belongs_to :conversation

  scope :ordered, -> {
    order(created_at: :desc)
  }

  scope :conversation_messages, -> {
    where(role: ["user", "assistant"])
  }

  def assistant?
    role == "assistant"
  end

  def user?
    role == "user"
  end

  def user_name
    user? ? conversation.lead.name : conversation.assistant.name
  end
end

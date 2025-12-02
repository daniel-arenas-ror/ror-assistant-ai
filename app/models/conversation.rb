class Conversation < ApplicationRecord
  belongs_to :lead
  belongs_to :assistant
  belongs_to :company

  has_many :messages

  def conversation_messages
    messages.where(role: ["user", "assistant"])
  end
end

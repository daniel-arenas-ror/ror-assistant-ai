class Conversation < ApplicationRecord
  belongs_to :lead
  belongs_to :assistant
  belongs_to :company

  has_many :messages
end

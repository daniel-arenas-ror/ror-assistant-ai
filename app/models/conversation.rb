class Conversation < ApplicationRecord
  belongs_to :lead
  belongs_to :assistant
  has_many :messages
end

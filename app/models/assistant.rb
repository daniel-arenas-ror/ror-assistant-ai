class Assistant < ApplicationRecord
  belongs_to :company
  has_many :conversations
end

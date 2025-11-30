class AssistantTool < ApplicationRecord
  belongs_to :assistant
  belongs_to :tool

  validates :tool_id, uniqueness: { scope: :assistant_id }
end

class Assistant < ApplicationRecord
  slug :title_for_slug

  belongs_to :company
  has_many :conversations
  has_many :assistant_tools
  has_many :tools, through: :assistant_tools

  accepts_nested_attributes_for :assistant_tools, allow_destroy: true

  def title_for_slug
    "#{name}-#{assistant_id.last(6)}#{company.id}".downcase
  end

  def version
    updated_at.to_i
  end

  def use_openai?
    company.ai_source == "openai"
  end

  def full_instructions
    [
      role,
      task,
      context,
      reasoning,
      outputs,
      conditions
    ].compact.join("\n\n")
  end
end

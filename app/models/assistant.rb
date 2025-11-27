class Assistant < ApplicationRecord
  slug :title_for_slug

  belongs_to :company
  has_many :conversations

  def title_for_slug
    "#{name}-#{assistant_id.last(6)}#{company.id}".downcase
  end

  def version
    updated_at.to_i
  end
end

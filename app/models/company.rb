class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :quotes, dependent: :destroy
  has_many :products
  has_many :assistants
  has_many :conversations
  has_many :leadCompany
  has_many :leads, through: :leadCompany

  validates :name, presence: true

  def assistant_name
    assistants.first&.name || "Asistente"
  end

  def assistant_slug
    assistants.first&.slug
  end

  def assistant
    assistants.first
  end
end

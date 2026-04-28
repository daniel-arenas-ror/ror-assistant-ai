class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :quotes, dependent: :destroy
  has_many :products
  has_many :assistants
  has_many :conversations
  has_many :leadCompany
  has_many :leads, through: :leadCompany
  has_many :option_types, dependent: :destroy
  has_many :option_values, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :company_item_configurations, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :page_layouts, dependent: :destroy
  has_one :payment_setting, dependent: :destroy

  accepts_nested_attributes_for :payment_setting, update_only: true

  validates :name, presence: true

  has_one_attached :icon

  delegate :provider_name, :settings, to: :payment_setting, allow_nil: true

  def assistant_name
    assistants.first&.name || "Asistente"
  end

  def assistant_slug
    assistants.first&.slug
  end

  def assistant
    assistants.first
  end

  def build_default_payment_setting
    build_payment_setting if payment_setting.nil?
  end
end

# frozen_string_literal: true

module Types
  class CompanyType < Types::BaseObject
    description "A company that owns various resources such as users, products, and categories."

    field :id, ID, null: false
    field :name, String, null: false
    field :icon_url, String, null: true, description: "URL of the company's icon image."
    field :company_item_configurations, [CompanyItemConfigurationsType], null: true, description: "Item configurations for the company."
    field :categories, CategoryType.connection_type, null: true, description: "Root categories belonging to the company."
    field :product_card_configuration, String, null: true, description: "Product card configuration for the company."
    field :product_detail_configuration, String, null: true, description: "Product detail configuration for the company."

    def product_card_configuration
      object.company_item_configurations.find_by(name: "ProductCardStyle")&.value
    end

    def categories
      object.categories.where(parent_id: nil).order(:name)
    end

    def icon_url
      Rails.application.routes.url_helpers.rails_blob_url(object.icon) if object.icon.attached?
    end

    def product_detail_configuration
      object.company_item_configurations.find_by(name: "ProductDetailStyle")&.value
    end
  end
end

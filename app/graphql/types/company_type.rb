# frozen_string_literal: true

module Types
  class CompanyType < Types::BaseObject
    description "A company that owns various resources such as users, products, and categories."

    field :id, ID, null: false
    field :name, String, null: false
    field :icon_url, String, null: true, description: "URL of the company's icon image."

    # associations we might need
    field :categories, CategoryType.connection_type, null: true,
          description: "Root categories belonging to the company."

    def categories
      object.categories.where(parent_id: nil).order(:name)
    end

    def icon_url
      object.icon.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.icon, only_path: true) : nil
    end
  end
end

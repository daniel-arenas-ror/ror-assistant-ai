# frozen_string_literal: true

module Types
  class CategoryType < Types::BaseObject
    description "A category belonging to a company. May have sub-categories."

    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: true
    field :company_id, ID, null: false

    # parent category (nullable)
    field :parent_category, CategoryType, null: true

    # sub-categories connection so clients can paginate children as well
    field :sub_categories, CategoryType.connection_type, null: true,
          description: "The child categories of this category."

    def sub_categories
      object.sub_categories.order(:name)
    end
  end
end

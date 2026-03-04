# frozen_string_literal: true

module Types
  class CompanyType < Types::BaseObject
    description "A company that owns various resources such as users, products, and categories."

    field :id, ID, null: false
    field :name, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # associations we might need
    field :categories, CategoryType.connection_type, null: true,
          description: "Root categories belonging to the company."

    def categories
      object.categories.where(parent_id: nil).order(:name)
    end
  end
end

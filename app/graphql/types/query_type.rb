# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject

    #include Queries::Node
    #include Queries::Category
    #include Queries::Company

    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # fetch root categories for a company with optional page/limit
    field :company_categories, [Types::CategoryType], null: false do
      description "Return top‑level categories for a company. Accepts pagination via limit/page."
      argument :company_id, ID, required: true
      argument :limit, Integer, required: false, default_value: 20
      argument :page, Integer, required: false, default_value: 1
    end

    def company_categories(company_id:, limit:, page:)
      Category.where(company_id: company_id, parent_id: nil)
              .includes(:sub_categories)
              .order(:name)
              .limit(limit)
              .offset((page - 1) * limit)
    end

    # lookup a company by id
    field :company, Types::CompanyType, null: true do
      description "Return a company record by id."
      argument :company_id, ID, required: true
    end

    def company(company_id:)
      Company.find_by(id: company_id)
    end
  end
end

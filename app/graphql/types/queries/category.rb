# frozen_string_literal: true

module Types
  module Queries
    module Category
      def self.included(base)
        base.field :company_categories, [Types::CategoryType], null: false do
          description "Return top‑level categories for a company. Accepts pagination via limit/page."
          argument :company_id, ID, required: true
          argument :limit, Integer, required: false, default_value: 20
          argument :page, Integer, required: false, default_value: 1
        end
      end

      def company_categories(company_id:, limit:, page:)
        ::Category.where(company_id: company_id, parent_id: nil)
                  .includes(:sub_categories)
                  .order(:name)
                  .limit(limit)
                  .offset((page - 1) * limit)
      end
    end
  end
end

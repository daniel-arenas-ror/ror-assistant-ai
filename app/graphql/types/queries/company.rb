# frozen_string_literal: true

module Types
  module Queries
    module Company
      def self.included(base)
        base.field :company, Types::CompanyType, null: true do
          description "Return a company record by id."
          argument :company_id, ID, required: true
        end
      end

      def company(company_id:)
        ::Company.find_by(id: company_id)
      end
    end
  end
end

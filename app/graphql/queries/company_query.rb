module Queries
  class CompanyQuery < BaseQuery
    type Types::CompanyType, null: false
    argument :company_id, ID, required: true

    description "Returns a list of all companies."

    def resolve(company_id: , **args)
      Company.find_by(id: company_id)
    end
  end
end

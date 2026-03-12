# frozen_string_literal: true

module Types
  class CompanyItemConfigurationsType < Types::BaseObject
    description "A company item configuration."

    field :id, ID, null: false
    field :name, String, null: false
    field :value, String, null: false

  end
end

# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
    field_class Types::BaseField

    def formatted_price
      # Include Helper to use the method
      ActionController::Base.helpers.humanized_money_with_symbol(object.price)
    end

    def formatted_total
      # Include Helper to use the method
      ActionController::Base.helpers.humanized_money_with_symbol(object.total)
    end

    def formatted_sub_total
      # Include Helper to use the method
      ActionController::Base.helpers.humanized_money_with_symbol(object.sub_total)
    end
  end
end

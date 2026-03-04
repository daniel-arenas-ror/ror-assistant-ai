# frozen_string_literal: true

module Types
  module Queries
    module Node
      def self.included(base)
        base.field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
          argument :id, ID, required: true, description: "ID of the object."
        end

        base.field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
          argument :ids, [ID], required: true, description: "IDs of the objects."
        end
      end

      def node(id:)
        context.schema.object_from_id(id, context)
      end

      def nodes(ids:)
        ids.map { |id| context.schema.object_from_id(id, context) }
      end
    end
  end
end

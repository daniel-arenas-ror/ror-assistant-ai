module Types
  class OrderType < Types::BaseObject
    field :id,                  ID,     null: false
    field :sub_total_cents,     Integer, null: false
    field :total_cents,         Integer, null: false
    field :formatted_total,     String,  null: true
    field :formatted_sub_total, String,  null: true

  end
end

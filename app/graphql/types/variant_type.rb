module Types
  class VariantType < Types::BaseObject
    description "A variant of a product."

    field :id, ID, null: false
    field :sku, String, null: false
    field :price, Float, null: false
    field :option_values, [Types::OptionValueType], null: true
    field :images, [Types::ImageType], null: true

  end
end

module Types
  class VariantType < Types::BaseObject
    description "A variant of a product."

    field :id, ID, null: false
    field :sku, String, null: false
    field :price, Float, null: false
    field :is_master, Boolean, null: false
    field :formatted_price, String, null: true
    field :option_values, [Types::OptionValueType], null: true
    field :images, [Types::ImageType], null: true

    def images
      object.images + object.product.product_option_values.select{|opv| object.option_value_ids.include?(opv.option_value_id)}.flat_map(&:images)
    end
  end
end
